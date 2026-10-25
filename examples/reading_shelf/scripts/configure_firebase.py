#!/usr/bin/env python3
"""Generate one environment's Dart Firebase options without editing native runners.

Cloud app registration is performed by FlutterFire when this script is run for real.
Use --dry-run to review the command without accessing Firebase.
"""

import argparse
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('environment', choices=['staging', 'production'])
    parser.add_argument('project_id', help='Existing Firebase project ID')
    parser.add_argument('web_app_id', help='Explicit Firebase Web app ID in that project')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    if args.project_id.startswith('-') or not args.web_app_id.startswith('1:') or ':web:' not in args.web_app_id:
        parser.error('Supply a project ID and a Firebase Web app ID (1:...:web:...).')

    app_root = Path(__file__).resolve().parents[1]
    bundle_id = 'com.example.readingshelf'
    if args.environment == 'staging':
        bundle_id += '.staging'
    destination = app_root / 'lib/core/services/firebase/options' / args.environment / 'firebase_options.dart'
    command = [
        'fvm', 'dart', 'pub', 'global', 'run', 'flutterfire_cli:flutterfire',
        'configure', '--yes', f'--project={args.project_id}',
        '--platforms=android,ios,web',
        f'--android-package-name={bundle_id}', f'--ios-bundle-id={bundle_id}',
        f'--web-app-id={args.web_app_id}', '--out=lib/firebase_options.dart',
        '--no-apply-gradle-plugins',
    ]
    if args.dry_run:
        print('Working directory: temporary Flutter package (Dart options only)')
        print(shlex.join(command))
        print(f'Copy generated output to: {destination.relative_to(app_root)}')
        return

    # This sample uses Core/Auth/Firestore with explicit FirebaseOptions. Running
    # configure inside the real app would also bundle native files/build phases,
    # potentially making local depend on cloud files. Keep that work isolated.
    with tempfile.TemporaryDirectory(prefix='reading-shelf-flutterfire-') as directory:
        temporary = Path(directory)
        (temporary / 'lib').mkdir()
        (temporary / 'pubspec.yaml').write_text(
            'name: reading_shelf\npublish_to: none\n'
            'dependencies:\n  flutter:\n    sdk: flutter\n',
            encoding='utf-8',
        )
        shutil.copyfile(app_root / '.fvmrc', temporary / '.fvmrc')
        # Disable interactive CLI update prompts; project/platform choices are explicit.
        subprocess.run(command, cwd=temporary, env={**os.environ, 'CI': 'true'}, check=True)
        generated = temporary / 'lib/firebase_options.dart'
        if not generated.is_file():
            raise RuntimeError('FlutterFire did not generate firebase_options.dart; existing file preserved.')
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(generated, destination)
    print(f'Generated: {destination.relative_to(app_root)}')
    print('Review the generated public client configuration before committing it.')


if __name__ == '__main__':
    main()
