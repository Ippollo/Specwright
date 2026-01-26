import sys
import yaml
import re

def lint_openapi(file_path):
    try:
        with open(file_path, 'r') as f:
            spec = yaml.safe_load(f)
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return

    print(f"🔍 Linting {file_path}...\n")
    errors = []
    warnings = []

    paths = spec.get('paths', {})
    
    # 1. Check for verbs in paths (Anti-pattern)
    verb_regex = re.compile(r'/(get|create|update|delete|patch)[A-Z-]', re.IGNORECASE)
    
    for path in paths.keys():
        if verb_regex.search(path):
            errors.append(f"Verbs in URI (Anti-Pattern): '{path}'. Use HTTP methods instead.")
        
        # 2. Check for kebab-case in URIs
        # Allow {params}, but check static parts.
        segments = [s for s in path.split('/') if s and not s.startswith('{')]
        for seg in segments:
            if not re.match(r'^[a-z0-9-]+$', seg):
                warnings.append(f"URI segment not strictly kebab-case: '{seg}' in '{path}'")

    # 3. Check for Security Definitions
    components = spec.get('components', {})
    security_schemes = components.get('securitySchemes', {})
    if not security_schemes:
        errors.append("Missing 'securitySchemes' in components. Secure your API.")

    # 4. Check for Standard Error Envelope
    schemas = components.get('schemas', {})
    if 'ErrorResponse' not in schemas and 'Error' not in schemas:
        warnings.append("No standard 'Error' or 'ErrorResponse' schema found. Standardization recommended.")

    # Report
    if not errors and not warnings:
        print("✅ No issues found! Good job.")
    else:
        for err in errors:
            print(f"❌ [ERROR] {err}")
        for warn in warnings:
            print(f"⚠️  [WARN] {warn}")
        
    print(f"\nSummary: {len(errors)} errors, {len(warnings)} warnings.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python api_linter.py <openapi.yaml>")
        sys.exit(1)
    
    lint_openapi(sys.argv[1])
