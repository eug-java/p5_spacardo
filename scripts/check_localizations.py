#!/usr/bin/env python3
"""Validate every committed Flutter ARB translation against the English schema."""
from pathlib import Path
import json
import re
import sys

root = Path(__file__).resolve().parents[1]
base = root / 'apps/mobile/lib/l10n'
expected = {'en', 'es', 'pt_BR', 'de', 'fr', 'ru', 'zh_CN', 'ja', 'ko', 'id', 'hi', 'ar', 'tr', 'vi', 'it', 'zh_TW', 'pl', 'uk'}
errors = []
files = {p.stem.removeprefix('app_'): p for p in base.glob('app_*.arb')}
# Flutter requires base locales for regional translations.
fallback_locales = {'pt', 'zh'}
expected = expected | fallback_locales

if files.keys() != expected:
    errors.append(f'Locale difference: missing={sorted(expected - files.keys())}, extra={sorted(files.keys() - expected)}')
english = json.loads((base / 'app_en.arb').read_text(encoding='utf-8'))
english_keys = {k for k in english if not k.startswith('@')}
for locale, path in sorted(files.items()):
    try:
        content = json.loads(path.read_text(encoding='utf-8'))
        keys = {k for k in content if not k.startswith('@')}
        if keys != english_keys:
            errors.append(f'{path.name}: missing={sorted(english_keys - keys)}, extra={sorted(keys - english_keys)}')
        if content.get('@@locale') != locale:
            errors.append(f'{path.name}: @@locale mismatch')
        for key in keys & english_keys:
            value = content[key]
            if not isinstance(value, str) or not value.strip():
                errors.append(f'{path.name}: empty or invalid translation: {key}')
            else:
                placeholders = lambda text: set(re.findall(r'\{([a-zA-Z][a-zA-Z0-9]*)\}', text))
                if placeholders(value) != placeholders(english[key]):
                    errors.append(f'{path.name}: placeholder mismatch: {key}')
    except (ValueError, OSError) as exc:
        errors.append(f'{path.name}: {exc}')
if errors:
    print('\n'.join(errors))
    sys.exit(1)
print(f'Localization schema check passed: {len(files)} locales, {len(english_keys)} messages each. Human translation review remains required.')
