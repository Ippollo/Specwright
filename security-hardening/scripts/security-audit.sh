#!/bin/bash

# Security Audit Script
# Requires: ripgrep (rg)

echo "🔍 Starting Security Scan..."
echo "=============================="

echo -e "\n[1] Scanning for Hardcoded Secrets..."
# Looks for typical assignments of secrets
rg -i "(password|secret|api_key|token)\s*=\s*['\"][^'\"]+['\"]" --type-add 'web:*.{js,ts,jsx,tsx,py,rb,go}' -t web

echo -e "\n[2] Scanning for Potential SQL Injection..."
# Looks for f-strings in execute calls or format() usage in queries
rg "execute\(\s*f['\"]|format\(" --type py
rg "\.query\(\s*\`.*\$\{.*\}\`" --type-add 'ts:*.{ts,tsx,js}' -t ts

echo -e "\n[3] Scanning for Dangerous Functions (eval/exec)..."
rg "\b(eval|exec|dangerouslySetInnerHTML)\s*[:\(]" --type-add 'web:*.{js,ts,jsx,tsx,py}' -t web

echo -e "\n[4] Scanning for Security TODOs..."
rg -i "TODO.*security|FIXME.*security|HACK.*security"

echo -e "\n=============================="
echo "✅ Scan Complete."
