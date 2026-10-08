# Documentation: 01_01 - Stage and Prim
# Goal: Understand how a USD stage contains prims.
# Key concepts:
# - Stage: The composed scene opened by OpenUSD.
# - Prim: A scene object identified by its USD path.
# - defaultPrim: The entry point of a USD asset.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 01 prim hierarchy example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom, Gf


# ------------------------------------------------------------
# 1. Get current Stage
# ------------------------------------------------------------

stage = omni.usd.get_context().get_stage()

if stage is None:
    raise RuntimeError("No Stage is currently open in Isaac Sim.")


# ------------------------------------------------------------
# 2. Create hierarchy
#
# /World
#     /Robot
#         /Body
#         /Head
# ------------------------------------------------------------

world = UsdGeom.Xform.Define(
    stage,
    "/World"
)

stage.SetDefaultPrim(world.GetPrim())


robot = UsdGeom.Xform.Define(
    stage,
    "/World/Robot"
)


body = UsdGeom.Cube.Define(
    stage,
    "/World/Robot/Body"
)

body.GetSizeAttr().Set(2.0)

body.GetDisplayColorAttr().Set(
    [Gf.Vec3f(0.2, 0.5, 0.9)]
)


head = UsdGeom.Sphere.Define(
    stage,
    "/World/Robot/Head"
)

head.GetRadiusAttr().Set(0.75)

head.GetDisplayColorAttr().Set(
    [Gf.Vec3f(0.9, 0.4, 0.1)]
)


# ------------------------------------------------------------
# 3. Inspect Prim paths
# ------------------------------------------------------------

print()
print("=== Prim Hierarchy ===")
print()

print("World:")
print(world.GetPath())

print("Robot:")
print(robot.GetPath())

print("Body:")
print(body.GetPath())

print("Head:")
print(head.GetPath())


# ------------------------------------------------------------
# 4. Read children of /World/Robot
# ------------------------------------------------------------

print()
print("Children of /World/Robot:")

robot_prim = robot.GetPrim()

for child in robot_prim.GetChildren():
    print(
        " ",
        child.GetPath(),
        "type =",
        child.GetTypeName()
    )


# ------------------------------------------------------------
# 5. Find a Prim using its path
# ------------------------------------------------------------

found_prim = stage.GetPrimAtPath(
    "/World/Robot/Head"
)

print()
print("Prim found by path:")
print(found_prim.GetPath())

print()
print("Type:")
print(found_prim.GetTypeName())

print()
print("Lesson 02 completed.")
