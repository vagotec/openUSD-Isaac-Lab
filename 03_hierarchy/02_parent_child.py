# Documentation: 03_01 - Prim Hierarchy
# Goal: Understand parent-child relationships between prims.
# Key concepts:
# - Prim path: Identifies a prim within the scene hierarchy.
# - Parent: The prim containing a child prim.
# - Child: A prim nested beneath another prim.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 02 parent child example.
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
# 2. World
# ------------------------------------------------------------

world = UsdGeom.Xform.Define(
    stage,
    "/World"
)

stage.SetDefaultPrim(
    world.GetPrim()
)


# ------------------------------------------------------------
# 3. Robot = Parent Prim
# ------------------------------------------------------------

robot = UsdGeom.Xform.Define(
    stage,
    "/World/Robot"
)

robot_xform = UsdGeom.Xformable(
    robot.GetPrim()
)

robot_xform.ClearXformOpOrder()

robot_translate = robot_xform.AddTranslateOp()

robot_translate.Set(
    Gf.Vec3d(4.0, 0.0, 0.0)
)


# ------------------------------------------------------------
# 4. Body = Child of Robot
#
# Local position:
# (0, 0, 1)
# ------------------------------------------------------------

body = UsdGeom.Cube.Define(
    stage,
    "/World/Robot/Body"
)

body.GetSizeAttr().Set(2.0)

body.GetDisplayColorAttr().Set(
    [Gf.Vec3f(0.2, 0.5, 0.9)]
)

body_xform = UsdGeom.Xformable(
    body.GetPrim()
)

body_xform.ClearXformOpOrder()

body_xform.AddTranslateOp().Set(
    Gf.Vec3d(0.0, 0.0, 1.0)
)


# ------------------------------------------------------------
# 5. Head = Child of Robot
#
# Local position:
# (0, 0, 3)
# ------------------------------------------------------------

head = UsdGeom.Sphere.Define(
    stage,
    "/World/Robot/Head"
)

head.GetRadiusAttr().Set(0.75)

head.GetDisplayColorAttr().Set(
    [Gf.Vec3f(0.9, 0.4, 0.1)]
)

head_xform = UsdGeom.Xformable(
    head.GetPrim()
)

head_xform.ClearXformOpOrder()

head_xform.AddTranslateOp().Set(
    Gf.Vec3d(0.0, 0.0, 3.0)
)


# ------------------------------------------------------------
# 6. Read local transformations
# ------------------------------------------------------------

print()
print("=== Local coordinates ===")
print()

print("Robot local translation:")
print(robot_translate.Get())

print()

print("Body local transformation:")
print(
    body_xform.GetLocalTransformation()
)

print()

print("Head local transformation:")
print(
    head_xform.GetLocalTransformation()
)


# ------------------------------------------------------------
# 7. Calculate world transformations
# ------------------------------------------------------------

cache = UsdGeom.XformCache()

body_world = cache.GetLocalToWorldTransform(
    body.GetPrim()
)

head_world = cache.GetLocalToWorldTransform(
    head.GetPrim()
)

print()
print("=== World transformations ===")
print()

print("Body world position:")
print(body_world.ExtractTranslation())

print()

print("Head world position:")
print(head_world.ExtractTranslation())

print()
print("Lesson 04 completed.")
