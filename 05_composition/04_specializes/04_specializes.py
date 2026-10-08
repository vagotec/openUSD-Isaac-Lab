# Documentation: 05_04 - Specializes
# Goal: Understand specialization of reusable prim definitions.
# Key concepts:
# - specializes: Composition arc for fallback opinions.
# - Specialized prim: Prim that refines shared definitions.
# - Opinion strength: Determines the composed result.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 04 specializes example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "11_specializes/"
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
# Get specialized Robot
# ------------------------------------------------------------

robot = stage.GetPrimAtPath(
    "/World/HeavyRobot"
)

body_prim = stage.GetPrimAtPath(
    "/World/HeavyRobot/Body"
)

body = UsdGeom.Cube(body_prim)


# ------------------------------------------------------------
# Inspect
# ------------------------------------------------------------

print()
print("========================================")
print("SPECIALIZES")
print("========================================")

print()
print("Robot:")
print(robot.GetPath())

print()
print("Has authored specializes:")
print(robot.HasAuthoredSpecializes())

print()
print("Body:")
print(body_prim.GetPath())

print()
print("Final composed Body size:")
print(body.GetSizeAttr().Get())

print()
print("COMPOSED PRIMS:")
print()

for prim in stage.Traverse():
    print(prim.GetPath())

print()
print("========================================")
