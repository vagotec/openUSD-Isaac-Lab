# Documentation: 01_02 - Prim Specifiers
# Goal: Understand def, over, and class prim specifications.
# Key concepts:
# - def: Defines a prim.
# - over: Contributes opinions to an existing prim.
# - class: Defines reusable opinions for inheritance.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 02 prim specifiers example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
