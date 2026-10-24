import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest

SPEC = importlib.util.spec_from_file_location('runner', Path(__file__).resolve().parents[2]/'scripts/run_evals.py')
runner = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(runner)


class RunnerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.addCleanup(self.temp.cleanup)
        self.config = runner.read(runner.ROOT/'evals/evals.json')

    def test_configuration_and_paired_inputs(self):
        runner.validate(self.config)
        for case in self.config['evals']:
            a,b=self.root/(case['id']+'a'),self.root/(case['id']+'b')
            runner.prepare(case,a)
            runner.prepare(case,b)
            self.assertEqual(runner.hashes(a),runner.hashes(b))
        self.assertFalse(any(name.startswith('tests/') for name in runner.definition_hashes()))

    def test_explicit_models_and_isolation(self):
        for role,expected in [('solver','gpt-6-luna'),('judge','gpt-6-astra')]:
            cmd=runner.codex_args(self.config[role],self.root,self.root/'last',schema=self.root/'schema' if role=='judge' else None)
            self.assertEqual(cmd[cmd.index('-m')+1],expected)
            self.assertIn('--ignore-user-config',cmd)
            self.assertIn('skip_host_skill_discovery',cmd)
            self.assertIn('project_doc_max_bytes=0',cmd)
            self.assertTrue(any(x.startswith('skills.config=') for x in cmd))
            self.assertNotIn('--dangerously-bypass-approvals-and-sandbox',cmd)

    def test_timeout_and_nonzero_exit(self):
        result=runner.command([sys.executable,'-c','import time; time.sleep(10)'],self.root,self.root/'timeout.log',timeout=.05)
        self.assertEqual(result['status'],'timeout')
        result=runner.command([sys.executable,'-c','raise SystemExit(7)'],self.root,self.root/'fail.log')
        self.assertEqual(result['status'],'failed')
        self.assertEqual(result['exit_code'],7)

    def test_usage_missing_and_subsets(self):
        log=self.root/'events'
        log.write_text('warning\n{}\n')
        self.assertIsNone(runner.usage(log))
        log.write_text(json.dumps({'type':'turn.completed','usage':{'input_tokens':100,'output_tokens':20,'cached_input_tokens':50,'reasoning_output_tokens':10}}))
        self.assertEqual(runner.usage(log)['total_tokens'],120)

    def test_only_usage_limit_failures_are_resumable(self):
        run = self.root/'run'
        runner.save(run/'solve.json', {'status':'failed'})
        (run/'transcript.jsonl').write_text('{"type":"error","message":"You’ve hit your usage limit."}\n')
        self.assertTrue(runner.usage_limited(run, 'solver'))
        (run/'transcript.jsonl').write_text('{"type":"error","message":"compile failed"}\n')
        self.assertFalse(runner.usage_limited(run, 'solver'))

    def test_resumed_solver_archives_downstream_results(self):
        run = self.root/'run'
        runner.save(run/'verification.json', {'checks':[]})
        runner.save(run/'judge.json', {'status':'failed'})
        (run/'checks').mkdir()
        (run/'checks'/'analysis.log').write_text('old')
        runner.archive_downstream(run)
        self.assertFalse((run/'verification.json').exists())
        self.assertFalse((run/'judge.json').exists())
        self.assertTrue((run/'downstream-attempt-1/verification.json').exists())
        self.assertTrue((run/'downstream-attempt-1/checks/analysis.log').exists())

    def test_tree_diff_reports_changes_and_ignores_caches(self):
        a,b=self.root/'a',self.root/'b'
        for d in (a,b):
            (d/'lib').mkdir(parents=True)
            (d/'lib/same.dart').write_text('same')
        self.assertEqual(runner.tree_diff(a,b),[])
        (b/'.dart_tool').mkdir()
        (b/'.dart_tool/cache').write_text('x')
        (b/'pubspec.lock').write_text('x')
        self.assertEqual(runner.tree_diff(a,b),[])
        (a/'lib/same.dart').write_text('changed')
        (a/'test_only.dart').write_text('kept')
        (b/'lib/extra.dart').write_text('new')
        self.assertEqual(runner.tree_diff(a,b),['lib/extra.dart','lib/same.dart','test_only.dart'])

    def test_regeneration_requires_entry_point(self):
        run=self.root/'run'
        (run/'outputs/packages/reading_api').mkdir(parents=True)
        checks=[]
        runner.verify_regeneration(run,lambda *a,**k:self.fail('must not run'),checks)
        self.assertEqual(checks[0]['id'],'api_regeneration')
        self.assertEqual(checks[0]['status'],'failed')

    def test_regeneration_diff_is_recorded(self):
        run=self.root/'run'
        pkg=run/'outputs/packages/reading_api/lib'
        pkg.mkdir(parents=True)
        (pkg/'api.dart').write_text('v1')
        (run/'outputs/tool').mkdir()
        (run/'outputs/tool/generate_api.sh').write_text("printf v2 > packages/reading_api/lib/api.dart\n")
        checks=[]
        def check(name,cmd,cwd):
            result=runner.command(cmd,cwd,run/'checks'/f'{name}.log')
            checks.append(dict(result,id=name))
            return result['status']=='completed'
        runner.verify_regeneration(run,check,checks)
        diff=next(c for c in checks if c['id']=='api_regeneration_diff')
        self.assertEqual(diff['status'],'failed')
        self.assertEqual(diff['changed'],['lib/api.dart'])
        self.assertIn('lib/api.dart',(run/'checks/api_regeneration_diff.log').read_text())

    def test_skill_overrides_follow_symlinked_skills(self):
        source=self.root/'source'
        source.mkdir()
        (source/'SKILL.md').write_text('---\nname: linked\n---\n')
        (source/'fixtures/nested').mkdir(parents=True)
        (source/'fixtures/nested/SKILL.md').write_text('---\nname: nested\n---\n')
        skills=self.root/'skills'
        skills.mkdir()
        (skills/'linked').symlink_to(source,target_is_directory=True)
        overrides=runner.skill_overrides([skills,self.root/'missing'])
        self.assertIn(json.dumps(str(skills/'linked/SKILL.md')),overrides)
        self.assertIn(json.dumps(str(skills/'linked')),overrides)
        self.assertNotIn('nested',overrides)

    def test_run_codex_records_skill_set_change(self):
        calls=iter(['before','after'])
        original=(runner.skill_overrides,runner.command)
        self.addCleanup(lambda:(setattr(runner,'skill_overrides',original[0]),setattr(runner,'command',original[1])))
        runner.skill_overrides=lambda:next(calls)
        seen={}
        def fake_command(argv,*args,**kwargs):
            seen['argv']=argv
            return {'status':'completed'}
        runner.command=fake_command
        result=runner.run_codex(self.config['solver'],self.root,self.root/'last',self.root/'log',1,None,'x')
        self.assertTrue(result['skill_set_changed'])
        self.assertIn('before',seen['argv'])

    def test_preflight_retries_once_after_skill_set_change(self):
        original=runner.run_codex
        self.addCleanup(setattr,runner,'run_codex',original)
        attempts=[]
        def fake_run(role,cwd,last,log,*args,**kwargs):
            attempts.append(1)
            last.write_text('plugin-creator' if len(attempts)==1 else 'NO_SKILLS')
            log.write_text('{}')
            return {'status':'completed','skill_set_changed':len(attempts)==1}
        runner.run_codex=fake_run
        result=runner.preflight_role('solver',self.config['solver'],self.root,self.root,None)
        self.assertEqual(len(attempts),2)
        self.assertTrue(result['isolated'])
        self.assertTrue((self.root/'preflight-solver-stale.txt').exists())
        self.assertTrue((self.root/'preflight-solver-stale.jsonl').exists())

    def test_preflight_fails_if_skill_set_keeps_changing(self):
        original=runner.run_codex
        self.addCleanup(setattr,runner,'run_codex',original)
        def fake_run(role,cwd,last,log,*args,**kwargs):
            last.write_text('NO_SKILLS')
            return {'status':'completed','skill_set_changed':True}
        runner.run_codex=fake_run
        self.assertFalse(runner.preflight_role('judge',self.config['judge'],self.root,self.root,None)['isolated'])

    def test_only_usage_limited_preflight_is_archived(self):
        runner.save(self.root/'preflight.json',{'solver':{'status':'completed','isolated':True},'judge':{'status':'failed','isolated':False}})
        (self.root/'preflight-judge.jsonl').write_text('{"type":"error","message":"You’ve hit your usage limit."}\n')
        (self.root/'preflight-judge.txt').write_text('')
        self.assertTrue(runner.preflight_usage_limited(self.root))
        runner.archive_preflight(self.root)
        self.assertFalse((self.root/'preflight.json').exists())
        self.assertTrue((self.root/'preflight-attempt-1/preflight-judge.jsonl').exists())
        self.assertFalse(runner.preflight_usage_limited(self.root))
        runner.save(self.root/'preflight.json',{'judge':{'status':'completed','isolated':False}})
        (self.root/'preflight-judge.jsonl').write_text('{"type":"error","message":"You’ve hit your usage limit."}\n')
        self.assertFalse(runner.preflight_usage_limited(self.root))

    def test_grade_requires_all_ids_once(self):
        case=self.config['evals'][0]
        grade={'assertions':[{'id':a['id'],'status':'pass','evidence':'lib/file.dart:1'} for a in case['assertions']]}
        self.assertTrue(runner.valid_grade(grade,case))
        grade['assertions'][-1]=grade['assertions'][0]
        self.assertFalse(runner.valid_grade(grade,case))

    def test_ungraded_is_not_pass_and_mechanical_failure_stays(self):
        case=self.config['evals'][0]
        run=self.root/case['id']/'with_skill'
        runner.save(run/'solve.json',{'status':'completed'})
        runner.save(run/'judge.json',{'status':'completed'})
        runner.save(run/'grading.json',{'assertions':[{'id':a['id'],'status':'pass','evidence':'x'} for a in case['assertions']]})
        runner.save(run/'verification.json',{'checks':[{'id':'analysis','status':'failed'}]})
        results=runner.aggregate(self.config,self.root)
        current=next(r for r in results if r['case']==case['id'] and r['condition']=='with_skill')
        self.assertFalse(current['mechanical_all_passed'])
        absent=next(r for r in results if r['case']=='api')
        self.assertEqual(absent['scores']['functional']['passed'],0)
        self.assertEqual(absent['scores']['functional']['graded'],0)


if __name__=='__main__':
    unittest.main()
