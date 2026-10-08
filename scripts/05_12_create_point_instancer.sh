#!/usr/bin/env bash
# Documentation: 05_12 - PointInstancer
# Goal: Understand large groups of repeated geometry.
# Key concepts demonstrated by the generated lesson:
# - PointInstancer: Efficiently represents repeated prototypes.
# - protoIndices: Selects the prototype for each instance.
# - positions: Stores positions of individual instances.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 12 create point instancer.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/12_point_instancer"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA
# ============================================================

cat > "$LESSON/point_instancer.usda" <<'USDA'
#usda 1.0

# Goal:
# Create ten cubes using one PointInstancer.
# Understand prototypes, protoIndices, and positions.

(
    # defaultPrim: Default entry point of the USD asset.
    defaultPrim = "World"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"
)

# Xform: Groups objects and supports transformations.
def Xform "World"
{
    # PointInstancer: Creates many instances from prototypes.
    # Boxes: Name of the instancer prim.
    def PointInstancer "Boxes"
    {
        # rel: Defines a relationship to another prim.
        # prototypes: Lists the geometry sources.
        # The first target receives prototype index 0.
        rel prototypes = </World/Boxes/Prototypes/CubePrototype>

        # int[]: Array of integer values.
        # protoIndices: Selects a prototype for each instance.
        # 0: Use the first prototype in the prototypes relationship.
        # Ten entries create ten instances.
        int[] protoIndices = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

        # point3f[]: Array of 3D positions using float values.
        # positions: Defines the center position of each instance.
        # Each cube has size 2, so Z=1 keeps it above the ground.
        point3f[] positions = [
            (1, 1, 1),
            (4, 1, 1),
            (7, 1, 1),
            (10, 1, 1),
            (13, 1, 1),
            (16, 1, 1),
            (19, 1, 1),
            (22, 1, 1),
            (25, 1, 1),
            (28, 1, 1)
        ]

        # Scope: Organizes prims without adding a transformation.
        # Prototypes: Container for reusable source geometry.
        def Scope "Prototypes"
        {
            # Cube: Geometry used by all ten instances.
            # CubePrototype: Name of the source geometry.
            def Cube "CubePrototype"
            {
                # double: 64-bit floating-point value.
                # size: Length of each cube edge.
                double size = 2

                # color3f[]: Array of RGB color values.
                # primvars:displayColor: Standard display color.
                color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
            }
        }
    }
}
USDA

# ============================================================
# 2. PYTHON
# ============================================================

cat > "$LESSON/12_point_instancer.py" <<'PYTHON'
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
PYTHON

echo "Created:"
echo "  $LESSON/point_instancer.usda"
echo "  $LESSON/12_point_instancer.py"
