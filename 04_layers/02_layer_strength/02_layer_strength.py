# Documentation: 04_02 - Layer Strength
# Goal: Understand stronger and weaker layer opinions.
# Key concepts:
# - Layer strength: Determines which authored opinion wins.
# - Opinion: A value or metadata statement in a layer.
# - Composition: Combines opinions into a scene.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 02 layer strength example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "04_layers/"
    "06_layer_strength/"
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
# Get the ONE composed Body Prim
# ------------------------------------------------------------

body_prim = stage.GetPrimAtPath(
    "/Robot/Body"
)

if not body_prim.IsValid():
    raise RuntimeError(
        "Prim /Robot/Body was not found."
    )

body = UsdGeom.Cube(body_prim)


# ------------------------------------------------------------
# Read final composed value
# ------------------------------------------------------------

size = body.GetSizeAttr().Get()


print()
print("========================================")
print("LAYER STRENGTH")
print("========================================")
print()

print("Prim:")
print(body_prim.GetPath())

print()

print("Final composed size:")
print(size)

print()

print("Expected:")
print("robot.usda          -> size = 2")
print("robot_override.usda -> size = 4")
print()
print("RESULT              -> size = 4")

print()
print("========================================")
