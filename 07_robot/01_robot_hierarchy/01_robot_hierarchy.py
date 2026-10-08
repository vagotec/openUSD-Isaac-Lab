# Documentation: 07_01 - Robot Hierarchy
# Goal: Represent a robot as a hierarchy of USD prims.
# Key concepts:
# - Robot root: Parent prim organizing robot components.
# - Transform hierarchy: Defines component placement.
# - Child prim: Represents a nested robot component.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 01 robot hierarchy example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "07_robot/"
    "17_robot_hierarchy/"
    "robot.usda"
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


print()
print("========================================")
print("ROBOT HIERARCHY")
print("========================================")

for prim in stage.Traverse():

    print(
        prim.GetPath(),
        "type =",
        prim.GetTypeName()
    )


# ------------------------------------------------------------
# Read world positions
# ------------------------------------------------------------

cache = UsdGeom.XformCache()

for path in [
    "/World/Robot/Base",
    "/World/Robot/Arm",
    "/World/Robot/Arm/UpperArm",
    "/World/Robot/Arm/Forearm",
]:

    prim = stage.GetPrimAtPath(path)

    matrix = cache.GetLocalToWorldTransform(
        prim
    )

    print()
    print(path)
    print(
        "World position:",
        matrix.ExtractTranslation()
    )


print()
print("========================================")
print("Lesson 17 completed.")
print("========================================")
