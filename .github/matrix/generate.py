import os
import json
import subprocess

# Get changed files from the current commit
changed_files = subprocess.check_output(
    ['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', 'HEAD']
).decode().splitlines()

valid_folders = set()
for path in changed_files:
    if path.endswith('.scad'):
        parts = path.split('/')
        if len(parts) > 1:
            valid_folders.add(parts[0])

matrix = {'folder': sorted(valid_folders)}
print(f'matrix={json.dumps(matrix)}')
with open(os.environ['GITHUB_OUTPUT'], 'a') as f:
    f.write(f'matrix={json.dumps(matrix)}\n')
