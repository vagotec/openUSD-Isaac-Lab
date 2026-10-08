#!/usr/bin/env bash
# Documentation: 01_02 - Prim Specifiers
# Goal: Understand def, over, and class prim specifications.
# Key concepts demonstrated by the generated lesson:
# - def: Defines a prim.
# - over: Contributes opinions to an existing prim.
# - class: Defines reusable opinions for inheritance.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 01 02 create prim specifiers.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/01_basics/02_prim_specifiers"

mkdir -p "$LESSON"

# ============================================================
# 1. BASE LAYER
# ============================================================

cat > "$LESSON/base.usda" <<'USDA'
#usda 1.0

def Xform "World"
{
    def Cube "Box"
    {
        double size = 2
    }
}
USDA


# ============================================================
# 2. OVERRIDE LAYER
# ============================================================

cat > "$LESSON/override.usda" <<'USDA'
#usda 1.0

over "World"
{
    over "Box"
    {
        double size = 4
    }
}
USDA


# ============================================================
# 3. MAIN LAYER
#
# The class is inherited by a second cube.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"

    subLayers = [
        @override.usda@,
        @base.usda@
    ]
)

class Cube "BoxTemplate"
{
    double size = 3
}

over "World"
{
    def Cube "InheritedBox" (
        prepend inherits = </BoxTemplate>
    )
    {
        double3 xformOp:translate = (4, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]
    }
}
USDA


# ============================================================
# 4. PYTHON - INSPECT COMPOSED STAGE
# ============================================================

cat > "$LESSON/02_prim_specifiers.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import UsdGeom

USD_FILE = Path(__file__).with_name("main.usda")

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

print("\n=== CHAPTER 18: PRIM SPECIFIERS ===")

for path in [
    "/World/Box",
    "/World/InheritedBox",
]:
    prim = stage.GetPrimAtPath(path)

    if not prim.IsValid():
        raise RuntimeError(f"Missing prim: {path}")

    cube = UsdGeom.Cube(prim)

    print(f"\nPrim: {path}")
    print(f"Composed size: {cube.GetSizeAttr().Get()}")

    print("Prim Stack:")

    for spec in prim.GetPrimStack():
        print(
            f"  {spec.specifier} | "
            f"{Path(spec.layer.identifier).name}"
        )

print("\nExpected results:")
print("/World/Box          size = 4")
print("/World/InheritedBox size = 3")
PYTHON

echo "Chapter 18 created successfully."
echo "Location: $LESSON"
