#!/usr/bin/env bash
# Documentation: 01_06 - API Schemas
# Goal: Understand additional capabilities applied to prims.
# Key concepts demonstrated by the generated lesson:
# - API schema: Adds a defined interface to a prim.
# - Apply: Authors an applied API schema.
# - apiSchemas: Metadata recording applied API schemas.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 01 06 create api schemas.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/01_basics/06_api_schemas"

mkdir -p "$LESSON"

# ============================================================
# USDA
# ============================================================

cat > "$LESSON/api_schemas.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Z"
)

def Xform "World"
{
    def Cube "MyCube" (
        kind = "component"
    )
    {
        double size = 2

        double3 xformOp:translate = (1, 1, 1)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        float3[] extentsHint = [
            (-1, -1, -1),
            (1, 1, 1)
        ]
    }
}
USDA


# ============================================================
# PYTHON
# ============================================================

cat > "$LESSON/06_api_schemas.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import UsdGeom

USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "01_basics/06_api_schemas/api_schemas.usda"
)

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

prim = stage.GetPrimAtPath("/World/MyCube")

print("\n=== CHAPTER 21.2: API SCHEMAS ===")

print("Prim:", prim.GetPath())
print("Typed Schema:", prim.GetTypeName())
print("Is Cube:", prim.IsA(UsdGeom.Cube))

model_api = UsdGeom.ModelAPI(prim)

print("\nModelAPI:")
print("Kind:", prim.GetMetadata("kind"))
print("Extents Hint:", model_api.GetExtentsHintAttr().Get())

print("\nApplied API Schemas:")
print(prim.GetAppliedSchemas())

print("\nChapter 21.2 completed.")
PYTHON

echo "Chapter 21.2 created."
