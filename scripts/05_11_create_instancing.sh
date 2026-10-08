#!/usr/bin/env bash
# Documentation: 05_11 - Native Instancing
# Goal: Understand memory-efficient native USD instances.
# Key concepts demonstrated by the generated lesson:
# - instanceable: Enables instance sharing.
# - Prototype: Shared composed scene representation.
# - Instance: Prim using a shared prototype.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 11 create instancing.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/11_instancing"

mkdir -p "$LESSON"

# ============================================================
# 1. Reusable cube asset
# ============================================================

cat > "$LESSON/cube.usda" <<'USDA'
#usda 1.0

# Goal:
# Define reusable cube geometry for native USD instancing.

(
    # defaultPrim: The default entry point of this USD asset.
    defaultPrim = "CubeAsset"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"
)

# def: Defines a prim.
# Xform: Groups objects and supports transformations.
# CubeAsset: The root of our reusable asset.
def Xform "CubeAsset"
{
    # Cube: Typed schema representing cube geometry.
    def Cube "Geometry"
    {
        # double: A 64-bit floating-point value.
        # size: Length of each cube edge.
        double size = 2

        # color3f[]: Array of RGB colors.
        # primvars:displayColor: Standard display color primvar.
        color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
    }
}
USDA

# ============================================================
# 2. Scene with three instances
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0

# Goal:
# Create three independently positioned instances
# that share the same referenced cube geometry.

(
    # defaultPrim: Prim opened by default.
    defaultPrim = "World"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"
)

# Xform: Parent prim for the scene.
def Xform "World"
{
    # def Xform: Defines a transformable instance root.
    def Xform "Cube_A" (
        # references: Composition arc to an external USD asset.
        # @./cube.usda@: Relative path to the asset file.
        # </CubeAsset>: Prim path inside the asset.
        prepend references = @./cube.usda@</CubeAsset>

        # instanceable: Metadata allowing USD to share
        # the referenced prim hierarchy through a prototype.
        instanceable = true
    )
    {
        # double3: Three double values (X, Y, Z).
        # xformOp:translate: Position of the instance root.
        double3 xformOp:translate = (1, 1, 1)

        # uniform: Value is not intended to vary over time.
        # token[]: Array of token identifiers.
        # xformOpOrder: Active transforms and their order.
        uniform token[] xformOpOrder = ["xformOp:translate"]
    }

    # Second instance of the same cube asset.
    def Xform "Cube_B" (
        prepend references = @./cube.usda@</CubeAsset>
        instanceable = true
    )
    {
        # Position the second instance.
        double3 xformOp:translate = (4, 1, 1)

        # Apply the translation operation.
        uniform token[] xformOpOrder = ["xformOp:translate"]
    }

    # Third instance of the same cube asset.
    def Xform "Cube_C" (
        prepend references = @./cube.usda@</CubeAsset>
        instanceable = true
    )
    {
        # Position the third instance.
        double3 xformOp:translate = (7, 1, 1)

        # Apply the translation operation.
        uniform token[] xformOpOrder = ["xformOp:translate"]
    }
}
USDA

# ============================================================
# 3. Inspect instances and prototypes
# ============================================================

cat > "$LESSON/11_instancing.py" <<'PYTHON'
from pathlib import Path

import omni.usd

# The Isaac Sim VS Code server does not preserve __file__.
USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "05_composition/11_instancing/main.usda"
)

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

# Open the scene in Isaac Sim.
context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

print("\n=== INSTANCE AND PROTOTYPE ===")

# Inspect each instance root.
for name in ("Cube_A", "Cube_B", "Cube_C"):
    prim = stage.GetPrimAtPath(f"/World/{name}")

    if not prim.IsValid():
        raise RuntimeError(f"Prim not found: {name}")

    print(f"\nPrim: {prim.GetPath()}")
    print("Type:", prim.GetTypeName())
    print("Instanceable:", prim.IsInstanceable())
    print("Is Instance:", prim.IsInstance())

    if prim.IsInstance():
        # Each instance points to a shared prototype.
        prototype = prim.GetPrototype()
        print("Prototype:", prototype.GetPath())

# Inspect the prototypes created by USD.
print("\nPROTOTYPES")

prototypes = stage.GetPrototypes()

print("Number of prototypes:", len(prototypes))

for prototype in prototypes:
    print("Prototype:", prototype.GetPath())

    # Prototype children contain the shared geometry.
    for child in prototype.GetChildren():
        print("  Child:", child.GetPath())
        print("  Type:", child.GetTypeName())

print("\nExercise 26.1 completed.")
PYTHON

echo "Created:"
echo "  $LESSON/cube.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/11_instancing.py"
