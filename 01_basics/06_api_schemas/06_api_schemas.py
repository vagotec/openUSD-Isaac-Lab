# Documentation: 01_06 - API Schemas
# Goal: Understand additional capabilities applied to prims.
# Key concepts:
# - API schema: Adds a defined interface to a prim.
# - Apply: Authors an applied API schema.
# - apiSchemas: Metadata recording applied API schemas.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 06 api schemas example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
