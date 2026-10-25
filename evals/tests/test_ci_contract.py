import importlib.util
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


contract = load('ci_contract', ROOT/'evals/checks/ci_contract.py')
runner = load('runner', ROOT/'scripts/run_evals.py')

WORKFLOW = '''name: Deploy
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: |
          flutter build appbundle --release --flavor "$FLAVOR" \\
            --dart-define-from-file=config/ci.json
          flutter build web --release --dart-define-from-file=config/staging.json
'''


class CiContractTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.addCleanup(self.temp.cleanup)

    def write(self, name, text):
        path = self.root/name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def test_missing_workflows_fail(self):
        self.assertEqual(contract.check(self.root), ['.github/workflows: no workflow files'])

    def test_valid_workflow_with_continuations_passes(self):
        self.write('.github/workflows/deploy.yml', WORKFLOW)
        self.write('android/app/build.gradle.kts', 'storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")\n')
        self.assertEqual(contract.check(self.root), [])

    def test_flavor_misuse_is_reported(self):
        self.write('.github/workflows/deploy.yml', WORKFLOW)
        self.write('scripts/ci/build.sh', 'flutter build web --flavor staging\n'
                   'flutter build ipa --release\n'
                   'flutter build apk --flavor production --dart-define-from-file=config/staging.json\n')
        findings = contract.check(self.root)
        self.assertEqual(len(findings), 3)
        self.assertIn('web build passes --flavor', findings[0])
        self.assertIn('native build without --flavor', findings[1])
        self.assertIn('--flavor production with config/staging.json', findings[2])

    def test_docs_and_build_outputs_are_not_build_sources(self):
        self.write('.github/workflows/deploy.yml', WORKFLOW)
        self.write('README.md', 'flutter build ipa --release\n')
        self.write('build/cache/run.sh', 'flutter build ipa\n')
        self.assertEqual(contract.check(self.root), [])

    def test_committed_credentials_are_reported(self):
        self.write('.github/workflows/deploy.yml', WORKFLOW)
        self.write('android/upload.jks', 'binary')
        self.write('android/key.properties', 'storePassword=secret\n')
        self.write('ios/AuthKey.txt', '-----BEGIN PRIVATE KEY-----\n')
        self.write('android/app/build.gradle.kts', 'storePassword = "hunter22"\n')
        names = sorted(f.split(':')[0] for f in contract.check(self.root))
        self.assertEqual(names, ['android/app/build.gradle.kts', 'android/key.properties',
                                 'android/upload.jks', 'ios/AuthKey.txt'])


class CiRunnerTests(unittest.TestCase):
    def test_protected_paths_cover_changes_and_new_app_files(self):
        before = {'lib/a.dart': '1', 'config/staging.json': '2', 'README.md': '3', 'flavorizr.yaml': '4'}
        after = {'lib/a.dart': '1', 'lib/new.dart': '5', 'README.md': '6', 'flavorizr.yaml': '4',
                 'config/ci.json': '7'}
        self.assertEqual(runner.ci_protected(before, after),
                         ['config/staging.json', 'flavorizr.yaml', 'lib/a.dart', 'lib/new.dart'])

    def test_workflow_lint_command_is_pinned_without_install(self):
        original = runner.shutil.which
        self.addCleanup(setattr, runner.shutil, 'which', original)
        runner.shutil.which = lambda name: None
        self.assertEqual(runner.workflow_lint_command()[:3], ['uvx', '--from', runner.ACTIONLINT_PYPI])


if __name__ == '__main__':
    unittest.main()
