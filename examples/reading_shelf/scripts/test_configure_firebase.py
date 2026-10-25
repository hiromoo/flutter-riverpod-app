import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


class ConfigureFirebaseTest(unittest.TestCase):
    def test_generation_is_isolated_and_copies_only_dart_output(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            scripts = root / 'scripts'
            scripts.mkdir()
            script = scripts / 'configure_firebase.py'
            shutil.copyfile(Path(__file__).with_name('configure_firebase.py'), script)
            shutil.copyfile(Path(__file__).resolve().parents[1] / '.fvmrc', root / '.fvmrc')
            firebase_json = root / 'firebase.json'
            firebase_json.write_text('{"emulators":{"auth":{"port":9099}}}')
            original = firebase_json.read_bytes()
            executable = root / 'fvm'
            executable.write_text(
                '#!' + sys.executable + '\n'
                'import os, pathlib, sys, json\n'
                'p=pathlib.Path.cwd()\n'
                'assert not (p/"android").exists() and not (p/"ios").exists()\n'
                'assert os.environ["CI"] == "true"\n'
                'assert "--android-package-name=com.example.readingshelf.staging" in sys.argv\n'
                'assert "--ios-bundle-id=com.example.readingshelf.staging" in sys.argv\n'
                'assert "--web-app-id=1:123:web:abc" in sys.argv\n'
                '(p/"lib/firebase_options.dart").write_text("// fake CLI output\\n")\n'
            )
            executable.chmod(0o755)
            subprocess.run(
                [sys.executable, str(script), 'staging', 'test-project', '1:123:web:abc'],
                env={**os.environ, 'PATH': str(root) + os.pathsep + os.environ['PATH']},
                check=True, capture_output=True,
            )
            output = root / 'lib/core/services/firebase/options/staging/firebase_options.dart'
            self.assertEqual(output.read_text(), '// fake CLI output\n')
            self.assertEqual(firebase_json.read_bytes(), original)
            self.assertFalse((root / 'android').exists())
            self.assertFalse((root / 'ios').exists())

    def test_local_cannot_be_configured_against_cloud(self):
        result = subprocess.run(
            [sys.executable, str(Path(__file__).with_name('configure_firebase.py')),
             'local', 'test-project', '1:123:web:abc', '--dry-run'],
            capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)

    def test_cli_failure_preserves_existing_configuration(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'scripts').mkdir()
            script = root / 'scripts/configure_firebase.py'
            shutil.copyfile(Path(__file__).with_name('configure_firebase.py'), script)
            shutil.copyfile(Path(__file__).resolve().parents[1] / '.fvmrc', root / '.fvmrc')
            output = root / 'lib/core/services/firebase/options/staging/firebase_options.dart'
            output.parent.mkdir(parents=True)
            output.write_text('// existing configuration\n')
            executable = root / 'fvm'
            executable.write_text('#!' + sys.executable + '\nraise SystemExit(1)\n')
            executable.chmod(0o755)
            result = subprocess.run(
                [sys.executable, str(script), 'staging', 'test-project', '1:123:web:abc'],
                env={**os.environ, 'PATH': str(root) + os.pathsep + os.environ['PATH']},
                capture_output=True,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(output.read_text(), '// existing configuration\n')

    def test_production_dry_run_has_no_environment_suffix(self):
        result = subprocess.run(
            [sys.executable, str(Path(__file__).with_name('configure_firebase.py')),
             'production', 'test-project', '1:123:web:abc', '--dry-run'],
            capture_output=True, text=True, check=True,
        )
        self.assertIn('--android-package-name=com.example.readingshelf ', result.stdout)
        self.assertIn('--ios-bundle-id=com.example.readingshelf ', result.stdout)
        self.assertNotIn('readingshelf.production', result.stdout)


if __name__ == '__main__':
    unittest.main()
