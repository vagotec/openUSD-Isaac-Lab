# Documentation: 05_07 - Variants vs References
# Goal: Compare variant selection with external asset references.
# Key concepts:
# - VariantSet: Defines alternative authored opinions.
# - Variant selection: Chooses one alternative.
# - Reference: Composes content from another prim or asset.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 07 variant vs reference example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "14_variant_vs_reference/"
    "main.usda"
)


context = omni.usd.get_context()

success = context.open_stage(USD_FILE)

if not success:
    raise RuntimeError(
        f"Could not open Stage: {USD_FILE}"
    )

stage = context.get_stage()

if stage is None:
    raise RuntimeError("No Stage available.")


body_prim = stage.GetPrimAtPath(
    "/World/Robot/Body"
)

if not body_prim.IsValid():
    raise RuntimeError(
        "/World/Robot/Body not found."
    )

body = UsdGeom.Cube(body_prim)


print()
print("========================================")
print("VARIANT vs REFERENCE")
print("========================================")

print()
print("Reference opinion:")
print("size = 2")

print()
print("Variant opinion:")
print("size = 4")

print()
print("Final composed size:")
print(body.GetSizeAttr().Get())

print()
print("Expected:")
print("V > R")
print("Therefore size = 4")

print()
print("========================================")
