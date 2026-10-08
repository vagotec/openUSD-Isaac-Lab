#!/usr/bin/env bash
# Documentation: 03_02 - Parent-Child Transforms
# Goal: Understand how parent transformations affect children.
# Key concepts demonstrated by the generated lesson:
# - Local transform: Transform relative to the parent.
# - World transform: Result of accumulated parent transforms.
# - Xformable: Schema interface for transformation operations.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 03 02 create parent child transforms.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/03_hierarchy"

mkdir -p "$LESSON"

# ============================================================
# 04A - Parent/Child transforms in USDA
# ============================================================

cat > "$LESSON/04_parent_child.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Z"
)

def Xform "World"
{
    def Xform "Robot"
    {
        double3 xformOp:translate = (4, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        def Cube "Body"
        {
            double size = 2

            double3 xformOp:translate = (0, 0, 1)

            uniform token[] xformOpOrder = [
                "xformOp:translate"
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
# 04B - Same concept using Python
# ============================================================

cat > "$LESSON/02_parent_child.py" <<'PYTHON'
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
PYTHON


echo "=================================================="
echo " OpenUSD Lesson 04 created"
echo "=================================================="
echo
echo "USDA:"
echo "  $LESSON/04_parent_child.usda"
echo
echo "Python:"
echo "  $LESSON/02_parent_child.py"
