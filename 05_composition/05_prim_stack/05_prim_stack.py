# Documentation: 05_05 - Prim Stack
# Goal: Inspect all prim specifications contributing to a prim.
# Key concepts:
# - Prim stack: Ordered specifications composing one prim.
# - PrimSpec: Authored description of a prim in a layer.
# - Composition: Combines the prim stack into a result.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 05 prim stack example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "12_prim_stack/"
    "main.usda"
)


# ------------------------------------------------------------
# Open Stage
# ------------------------------------------------------------

context = omni.usd.get_context()

success = context.open_stage(USD_FILE)

if not success:
    raise RuntimeError(
        f"Could not open Stage: {USD_FILE}"
    )

stage = context.get_stage()

if stage is None:
    raise RuntimeError("No Stage available.")


# ------------------------------------------------------------
# Find composed Prim
# ------------------------------------------------------------

body_prim = stage.GetPrimAtPath(
    "/World/Robot/Body"
)

if not body_prim.IsValid():
    raise RuntimeError(
        "/World/Robot/Body not found."
    )

body = UsdGeom.Cube(body_prim)


# ------------------------------------------------------------
# 1. LAYER STACK
# ------------------------------------------------------------

print()
print("========================================")
print("1. LAYER STACK")
print("========================================")

for layer in stage.GetLayerStack():
    print(layer.identifier)


# ------------------------------------------------------------
# 2. PRIM STACK
#
# Which PrimSpecs contribute opinions
# to /World/Robot/Body?
# ------------------------------------------------------------

print()
print("========================================")
print("2. PRIM STACK")
print("========================================")

for prim_spec in body_prim.GetPrimStack():

    print()
    print("Layer:")
    print(prim_spec.layer.identifier)

    print("Prim path:")
    print(prim_spec.path)

    print("Specifier:")
    print(prim_spec.specifier)


# ------------------------------------------------------------
# 3. FINAL COMPOSED RESULT
# ------------------------------------------------------------

print()
print("========================================")
print("3. COMPOSED RESULT")
print("========================================")

print()
print("Prim:")
print(body_prim.GetPath())

print()
print("Type:")
print(body_prim.GetTypeName())

print()
print("Final size:")
print(body.GetSizeAttr().Get())

print()
print("Final color:")
print(body.GetDisplayColorAttr().Get())

print()
print("========================================")
