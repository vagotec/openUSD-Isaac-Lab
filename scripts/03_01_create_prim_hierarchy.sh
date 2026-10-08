#!/usr/bin/env bash
# Documentation: 03_01 - Prim Hierarchy
# Goal: Understand parent-child relationships between prims.
# Key concepts demonstrated by the generated lesson:
# - Prim path: Identifies a prim within the scene hierarchy.
# - Parent: The prim containing a child prim.
# - Child: A prim nested beneath another prim.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 03 01 create prim hierarchy.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/01_basics"

mkdir -p "$LESSON"

# ============================================================
# 02A - Prim hierarchy directly in USDA
# ============================================================

cat > "$LESSON/02_prim_hierarchy.usda" <<'USDA'
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
            color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
        }

        def Sphere "Head"
        {
            double radius = 0.75
            color3f[] primvars:displayColor = [(0.9, 0.4, 0.1)]
        }
    }
}
USDA


# ============================================================
# 02B - Same hierarchy using Python in Isaac Sim
# ============================================================

cat > "$LESSON/01_prim_hierarchy.py" <<'PYTHON'
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
PYTHON


echo "=================================================="
echo " OpenUSD Lesson 02 created"
echo "=================================================="
echo
echo "USDA:"
echo "  $LESSON/02_prim_hierarchy.usda"
echo
echo "Python:"
echo "  $LESSON/01_prim_hierarchy.py"
