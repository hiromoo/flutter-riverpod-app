#!/usr/bin/env python3
"""Static CI/CD contract for the ci case. Standard library only; prints findings, exits 1 on any."""
from __future__ import annotations

from pathlib import Path
import re
import sys

IGNORED_DIRS = {'.git', '.dart_tool', 'build', '.fvm', 'node_modules', 'Pods', '.gradle', '.kotlin'}
NATIVE = {'apk', 'appbundle', 'aab', 'ios', 'ipa'}
ENVIRONMENTS = {'local', 'staging', 'production'}
SECRET_FILES = {'.jks', '.keystore', '.p8', '.p12', '.pem', '.mobileprovision'}
SECRET_TEXT = [
    re.compile(r'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'),
    re.compile(r'sb_secret_[A-Za-z0-9_-]{8,}'),
    re.compile(r'(?:store|key)Password\s*=\s*["\'][^"\'$]{4,}["\']'),
]


def files(root):
    for path in sorted(root.rglob('*')):
        if path.is_file() and not IGNORED_DIRS.intersection(path.relative_to(root).parts):
            yield path


def logical_lines(text):
    """Join shell continuations so one build command is one line."""
    return re.sub(r'\\\n\s*', ' ', text).splitlines()


def build_findings(name, text):
    found = []
    for line in logical_lines(text):
        for match in re.finditer(r'flutter\s+build\s+([a-z]+)', line):
            target, rest = match.group(1), line[match.end():]
            flavor = re.search(r'--flavor[=\s]+["\']?([A-Za-z0-9_${}.\-]+)', rest)
            config = re.search(r'--dart-define-from-file[=\s]+["\']?config/([a-z]+)\.json', rest)
            if target == 'web' and flavor:
                found.append(f'{name}: web build passes --flavor: {line.strip()}')
            elif target in NATIVE and not flavor:
                found.append(f'{name}: native build without --flavor: {line.strip()}')
            elif target in NATIVE and flavor.group(1) in ENVIRONMENTS and config and config.group(1) != flavor.group(1):
                found.append(f'{name}: --flavor {flavor.group(1)} with config/{config.group(1)}.json: {line.strip()}')
    return found


def check(root):
    root = Path(root)
    findings = []
    workflows = [p for p in (root/'.github/workflows').glob('*') if p.suffix in ('.yml', '.yaml')]
    if not workflows:
        findings.append('.github/workflows: no workflow files')
    for path in files(root):
        name = path.relative_to(root).as_posix()
        if path.suffix.lower() in SECRET_FILES or path.name == 'key.properties':
            findings.append(f'{name}: credential file committed')
            continue
        try:
            text = path.read_text()
        except (UnicodeDecodeError, OSError):
            continue
        findings += [f'{name}: credential-like content ({p.pattern})' for p in SECRET_TEXT if p.search(text)]
        if name.startswith('.github/') or path.suffix == '.sh' or path.name == 'Fastfile':
            findings += build_findings(name, text)
    return findings


def main():
    findings = check(sys.argv[1] if len(sys.argv) > 1 else '.')
    print('\n'.join(findings) if findings else 'CI contract: no findings.')
    raise SystemExit(1 if findings else 0)


if __name__ == '__main__':
    main()
