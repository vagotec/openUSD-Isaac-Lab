# Documentation: 01_05 - Typed Schemas
# Goal: Understand schema types such as Xform and Cube.
# Key concepts:
# - Typed schema: Defines the primary type of a prim.
# - Xform: Supports ordered transformation operations.
# - Cube: Provides built-in cube geometry.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 05 typed schemas example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
