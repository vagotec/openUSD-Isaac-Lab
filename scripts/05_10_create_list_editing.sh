#!/usr/bin/env bash
# Documentation: 05_10 - List Editing
# Goal: Understand how USD list operations affect composition.
# Key concepts demonstrated by the generated lesson:
# - prepend: Adds items before weaker list contributions.
# - delete: Removes matching items from weaker lists.
# - Reference list: Stores composition references on a prim.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 10 create list editing.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/10_list_editing"

mkdir -p "$LESSON"

# ============================================================
# 1. BASE USDA
# ============================================================

cat > "$LESSON/base.usda" <<'USDA'
#usda 1.0

# Goal:
# Define reusable cube and sphere geometry for reference composition.

(
    # defaultPrim: Specifies the default entry point of this asset.
    defaultPrim = "World"

    # upAxis: Defines which axis points upward.
    upAxis = "Z"
)

# def: Defines a prim.
# Xform: Groups objects and supports transformations.
# World: The name of the parent prim.
def Xform "World"
{
    # Cube: A schema type representing cube geometry.
    def Cube "Box"
    {
        # double: A 64-bit floating-point data type.
        # size: The length of each cube edge.
        double size = 2

        # double3: Three double values for X, Y and Z.
        # xformOp:translate: Moves the cube to this position.
        double3 xformOp:translate = (1, 1, 1)

        # uniform: The attribute is not intended to vary over time.
        # token: A compact string-like identifier.
        # []: Indicates an array.
        # xformOpOrder: Specifies active transforms and their order.
        uniform token[] xformOpOrder = ["xformOp:translate"]

        # color3f: RGB color using three float components.
        # primvars: Namespace for geometry-related attributes.
        # displayColor: Standard display color primvar.
        color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
    }

    # Sphere: A schema type representing sphere geometry.
    def Sphere "Ball"
    {
        # double: A 64-bit floating-point data type.
        # radius: Distance from the center to the sphere surface.
        double radius = 1

        # double3: Three double values for X, Y and Z.
        # xformOp:translate: Positions the sphere center.
        double3 xformOp:translate = (5, 1, 1)

        # uniform: Indicates that the attribute is not time-varying.
        # token[]: An array of token values.
        # xformOpOrder: Defines active transforms and their order.
        uniform token[] xformOpOrder = ["xformOp:translate"]

        # color3f[]: Array of RGB color values.
        # primvars:displayColor: Standard display color primvar.
        color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
    }
}

USDA

# ============================================================
# 2. MAIN USDA
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0

# Goal:
# Understand how list editing modifies references.
# prepend adds a reference; delete removes a reference
# that was authored in a weaker layer.

(
    defaultPrim = "World"
    upAxis = "Z"
)

def Xform "World"
{
    # Create a prim that references the cube from base.usda.
    def "Object" (
        prepend references = @./base.usda@</World/Box>
    )
    {
    }
}
USDA

# ============================================================
# 3. PYTHON
# ============================================================

cat > "$LESSON/10_list_editing.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import Sdf, Usd

PROJECT = Path.home() / "projects/openUSD-Isaac-Lab"
USD_FILE = PROJECT / "05_composition/10_list_editing/main.usda"

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Cannot open {USD_FILE}")

stage = context.get_stage()
prim = stage.GetPrimAtPath("/World/Object")

if not prim.IsValid():
    raise RuntimeError("Missing /World/Object")

print("\n=== CHAPTER 23: LIST EDITING ===")
print("Composed type:", prim.GetTypeName())

root_spec = stage.GetRootLayer().GetPrimAtPath("/World/Object")
print("References:", root_spec.referenceList.prependedItems)

# Inspect list editing without modifying the visible stage.
# A separate in-memory layer demonstrates explicit reference removal.
layer = Sdf.Layer.CreateAnonymous("list_editing_demo.usda")
spec = Sdf.CreatePrimInLayer(layer, "/Example")

reference = Sdf.Reference("./example.usda", "/Example")

spec.referenceList.prependedItems = [reference]
print("Before removal:", spec.referenceList.prependedItems)

spec.referenceList.prependedItems = []
print("After removal:", spec.referenceList.prependedItems)

assert prim.GetTypeName() == "Cube"
assert len(spec.referenceList.prependedItems) == 0

print("PASS: Chapter 23")
PYTHON

echo "Created:"
echo "  $LESSON/base.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/10_list_editing.py"
