import os
import json

root_folders = [
    f for f in os.listdir('.')
    if os.path.isdir(f) and f not in ['.git', '.github']
]

# Only keep folders with at least one .scad file
valid_folders = []
for folder in root_folders:
    scad_files = [f for f in os.listdir(folder) if f.endswith('.scad')]
    if scad_files:
        valid_folders.append(folder)

# Output matrix
matrix = {'folder': valid_folders}
print(f'matrix={json.dumps(matrix)}')
with open(os.environ['GITHUB_OUTPUT'], 'a') as f:
    f.write(f'matrix={json.dumps(matrix)}\\n')