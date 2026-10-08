#!/usr/bin/env bash
# Documentation: 01_05 - Typed Schemas
# Goal: Understand schema types such as Xform and Cube.
# Key concepts demonstrated by the generated lesson:
# - Typed schema: Defines the primary type of a prim.
# - Xform: Supports ordered transformation operations.
# - Cube: Provides built-in cube geometry.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 01 05 create typed schemas.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/01_basics/05_typed_schemas"

mkdir -p "$LESSON"

# ============================================================
# USDA
# ============================================================

cat > "$LESSON/typed_schemas.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Z"
)

def Xform "World"
{
    def Cube "MyCube"
    {
        double size = 2

        double3 xformOp:translate = (1, 1, 1)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]
    }

    def Sphere "MySphere"
    {
        double radius = 1

        double3 xformOp:translate = (5, 1, 1)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]
    }

    def Xform "MyXform"
    {
        double3 xformOp:translate = (8, 1, 1)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]
    }
}
USDA


# ============================================================
# PYTHON
# ============================================================

cat > "$LESSON/05_typed_schemas.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import UsdGeom

USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "01_basics/05_typed_schemas/typed_schemas.usda"
)

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

print("\n=== CHAPTER 21.1: TYPED SCHEMAS ===")

for path in [
    "/World/MyCube",
    "/World/MySphere",
    "/World/MyXform",
]:
    prim = stage.GetPrimAtPath(path)

    print("\nPrim:", path)
    print("TypeName:", prim.GetTypeName())

    print("Is Cube:", prim.IsA(UsdGeom.Cube))
    print("Is Sphere:", prim.IsA(UsdGeom.Sphere))
    print("Is Xform:", prim.IsA(UsdGeom.Xform))

    print("Attributes:")

    for attr in prim.GetAttributes():
        print(" ", attr.GetName())

print("\nChapter 21.1 completed.")
PYTHON

echo "Chapter 21.1 created."
