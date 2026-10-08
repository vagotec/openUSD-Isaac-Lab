# Documentation: 05_12 - PointInstancer
# Goal: Understand large groups of repeated geometry.
# Key concepts:
# - PointInstancer: Efficiently represents repeated prototypes.
# - protoIndices: Selects the prototype for each instance.
# - positions: Stores positions of individual instances.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 12 point instancer example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

from pathlib import Path

import omni.usd
from pxr import UsdGeom

# Use an absolute path for the Isaac Sim Python server.
USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "05_composition/12_point_instancer/point_instancer.usda"
)

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

# Open the USDA scene.
context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

# Find the PointInstancer prim.
prim = stage.GetPrimAtPath("/World/Boxes")

if not prim.IsValid():
    raise RuntimeError("PointInstancer not found")

instancer = UsdGeom.PointInstancer(prim)

if not instancer:
    raise RuntimeError("Prim is not a PointInstancer")

# Read the prototype relationship and instance arrays.
prototypes = instancer.GetPrototypesRel().GetTargets()
indices = instancer.GetProtoIndicesAttr().Get()
positions = instancer.GetPositionsAttr().Get()

if indices is None or positions is None:
    raise RuntimeError("Instance arrays are missing")

if len(indices) != len(positions):
    raise RuntimeError("Instance array lengths do not match")

if not prototypes:
    raise RuntimeError("No prototypes defined")

if any(index < 0 or index >= len(prototypes) for index in indices):
    raise RuntimeError("Invalid prototype index")

print("\n=== POINT INSTANCER ===")

print("\n1. PRIM")
print("Path:", prim.GetPath())
print("Type:", prim.GetTypeName())

print("\n2. PROTOTYPES")
for index, path in enumerate(prototypes):
    print(f"Prototype {index}: {path}")

print("\n3. INSTANCES")
print("Number of instances:", len(indices))

for number, (index, position) in enumerate(zip(indices, positions)):
    print(f"Instance {number}: prototype={index}, position={tuple(position)}")

print("\nExercise 26.2 completed.")
