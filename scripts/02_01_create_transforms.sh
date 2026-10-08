#!/usr/bin/env bash
# Documentation: 02_01 - Transforms
# Goal: Understand translation, rotation, scale, and operation order.
# Key concepts demonstrated by the generated lesson:
# - xformOp: An individual transformation operation.
# - xformOpOrder: Defines the order of transformations.
# - Local transform: Transform relative to the parent prim.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 02 01 create transforms.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/02_transforms"

mkdir -p "$LESSON"

# ============================================================
# 03A - Transforms directly in USDA
# ============================================================

cat > "$LESSON/03_transforms.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Z"
)

def Xform "World"
{
    def Xform "Robot"
    {
        def Cube "Body"
        {
            double size = 2

            double3 xformOp:translate = (0, 0, 1)
            float3 xformOp:rotateXYZ = (0, 0, 0)
            float3 xformOp:scale = (1.5, 1, 1)

            uniform token[] xformOpOrder = [
                "xformOp:translate",
                "xformOp:rotateXYZ",
                "xformOp:scale"
            ]

            color3f[] primvars:displayColor = [
                (0.2, 0.5, 0.9)
            ]
        }

        def Sphere "Head"
        {
            double radius = 0.75

            double3 xformOp:translate = (0, 0, 3)

            uniform token[] xformOpOrder = [
                "xformOp:translate"
            ]

            color3f[] primvars:displayColor = [
                (0.9, 0.4, 0.1)
            ]
        }
    }
}
USDA


# ============================================================
# 03B - Same scene using Python / OpenUSD API
# ============================================================

cat > "$LESSON/01_transforms.py" <<'PYTHON'
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
PYTHON


echo "=================================================="
echo " OpenUSD Lesson 03 created"
echo "=================================================="
echo
echo "USDA:"
echo "  $LESSON/03_transforms.usda"
echo
echo "Python:"
echo "  $LESSON/01_transforms.py"
