# Documentation: 02_01 - Transforms
# Goal: Understand translation, rotation, scale, and operation order.
# Key concepts:
# - xformOp: An individual transformation operation.
# - xformOpOrder: Defines the order of transformations.
# - Local transform: Transform relative to the parent prim.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 01 transforms example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom, Gf


# ------------------------------------------------------------
# 1. Get current Stage
# ------------------------------------------------------------

stage = omni.usd.get_context().get_stage()

if stage is None:
    raise RuntimeError(
        "No Stage is currently open in Isaac Sim."
    )


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
# 3. Robot
# ------------------------------------------------------------

robot = UsdGeom.Xform.Define(
    stage,
    "/World/Robot"
)


# ------------------------------------------------------------
# 4. Body
# ------------------------------------------------------------

body = UsdGeom.Cube.Define(
    stage,
    "/World/Robot/Body"
)

body.GetSizeAttr().Set(2.0)

body.GetDisplayColorAttr().Set(
    [Gf.Vec3f(0.2, 0.5, 0.9)]
)


# ------------------------------------------------------------
# 5. Body transformations
# ------------------------------------------------------------

body_xform = UsdGeom.Xformable(
    body.GetPrim()
)

body_xform.ClearXformOpOrder()

body_translate = body_xform.AddTranslateOp()
body_rotate = body_xform.AddRotateXYZOp()
body_scale = body_xform.AddScaleOp()

body_translate.Set(
    Gf.Vec3d(0.0, 0.0, 1.0)
)

body_rotate.Set(
    Gf.Vec3f(0.0, 0.0, 0.0)
)

body_scale.Set(
    Gf.Vec3f(1.5, 1.0, 1.0)
)


# ------------------------------------------------------------
# 6. Head
# ------------------------------------------------------------

head = UsdGeom.Sphere.Define(
    stage,
    "/World/Robot/Head"
)

head.GetRadiusAttr().Set(0.75)

head.GetDisplayColorAttr().Set(
    [Gf.Vec3f(0.9, 0.4, 0.1)]
)


# ------------------------------------------------------------
# 7. Head transformation
# ------------------------------------------------------------

head_xform = UsdGeom.Xformable(
    head.GetPrim()
)

head_xform.ClearXformOpOrder()

head_translate = head_xform.AddTranslateOp()

head_translate.Set(
    Gf.Vec3d(0.0, 0.0, 3.0)
)


# ------------------------------------------------------------
# 8. Inspect transformation operations
# ------------------------------------------------------------

print()
print("=== OpenUSD Transformations ===")
print()

print("Body:")
print(body.GetPath())

for op in body_xform.GetOrderedXformOps():
    print(
        " ",
        op.GetOpName(),
        "=",
        op.Get()
    )

print()

print("Head:")
print(head.GetPath())

for op in head_xform.GetOrderedXformOps():
    print(
        " ",
        op.GetOpName(),
        "=",
        op.Get()
    )

print()
print("Lesson 03 completed.")
