import trimesh
import sys
import os

if len(sys.argv) < 2:
    print("Usage: python render.py <input.stl> [output.png]")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2] if len(sys.argv) > 2 else "preview.png"

# Validate extension
if not input_file.lower().endswith(".stl"):
    print("Error: input file must be an STL file.")
    sys.exit(1)

if not os.path.isfile(input_file):
    print(f"Error: file '{input_file}' does not exist.")
    sys.exit(1)

mesh = trimesh.load(input_file)
scene = mesh.scene()

# Save as PNG image
scene.save_image(output_file, resolution=(800, 600), visible=True)
print(f"Saved preview to {output_file}")
