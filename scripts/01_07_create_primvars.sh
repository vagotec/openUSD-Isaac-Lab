#!/usr/bin/env bash
# Documentation: 01_07 - Primvars
# Goal: Understand geometry-related primitive variables.
# Key concepts demonstrated by the generated lesson:
# - primvars: Namespace for geometry-related data.
# - displayColor: Standard display-color primvar.
# - Interpolation: Describes how primvar values map to geometry.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 01 07 create primvars.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/01_basics/07_primvars"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA
# ============================================================

cat > "$LESSON/primvars.usda" <<'USDA'
#usda 1.0

# Goal:
# Create a red cube and understand how OpenUSD stores
# geometry properties, transformations, and primvars.

(
    # Prim opened by default when loading this asset.
    defaultPrim = "World"

    # Z is the vertical axis.
    upAxis = "Z"
)

# Xform groups objects and can transform its children.
# Xform itself does not create visible geometry.
def Xform "World"
{
    # Cube is a typed schema for cube geometry.
    def Cube "Box"
    {
        # Length of each cube edge.
        double size = 2

        # Move the cube so its geometry starts at (0, 0, 0).
        # A cube with size 2 extends 1 unit around its center.
        double3 xformOp:translate = (1, 1, 1)

        # Specify which transformation operations are active
        # and in which order they are evaluated.
        uniform token[] xformOpOrder = ["xformOp:translate"]

        # primvars: is a property namespace.
        # displayColor is a standard primvar used for display color.
        # (1, 0, 0) represents red (RGB).
        color3f[] primvars:displayColor = [(1, 0, 0)] (
            # One color value applies to the entire cube.
            interpolation = "constant"
        )
    }
}

USDA

# ============================================================
# 2. PYTHON
# ============================================================

cat > "$LESSON/07_primvars.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import UsdGeom

USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "01_basics/07_primvars/primvars.usda"
)

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()
prim = stage.GetPrimAtPath("/World/Box")

if not prim.IsValid():
    raise RuntimeError("Prim /World/Box not found")

print("\n=== CHAPTER 22: NAMESPACES AND PRIMVARS ===")

# 1. Inspect all authored properties.
print("\n1. AUTHORED PROPERTIES")

for prop in prim.GetAuthoredProperties():
    print(" ", prop.GetName())

# 2. Inspect properties in the primvars namespace.
print("\n2. PRIMVARS NAMESPACE")

for prop in prim.GetAuthoredPropertiesInNamespace("primvars"):
    print(" ", prop.GetName())

# 3. Read the color through PrimvarsAPI.
print("\n3. PRIMVARS API")

primvars_api = UsdGeom.PrimvarsAPI(prim)
color = primvars_api.GetPrimvar("displayColor")

if not color:
    raise RuntimeError("Primvar displayColor not found")

print("Name:", color.GetName())
print("Value:", color.Get())
print("Interpolation:", color.GetInterpolation())

# 4. Compare with an ordinary attribute.
print("\n4. NORMAL ATTRIBUTE")

size = prim.GetAttribute("size")
print("Name:", size.GetName())
print("Value:", size.Get())

print("\nChapter 22 completed.")
PYTHON

echo "Chapter 22 created:"
echo "  $LESSON/primvars.usda"
echo "  $LESSON/07_primvars.py"
