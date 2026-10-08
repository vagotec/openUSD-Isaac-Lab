#!/usr/bin/env bash
# Documentation: 05_04 - Specializes
# Goal: Understand specialization of reusable prim definitions.
# Key concepts demonstrated by the generated lesson:
# - specializes: Composition arc for fallback opinions.
# - Specialized prim: Prim that refines shared definitions.
# - Opinion strength: Determines the composed result.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 04 create specializes.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/04_specializes"

mkdir -p "$LESSON"

# ============================================================
# USDA
#
# BaseRobot:
#   General robot definition
#
# HeavyRobot:
#   Specializes BaseRobot
#   and changes some properties.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
)

class Xform "BaseRobot"
{
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
    }
}


def Xform "World"
{
    def Xform "HeavyRobot" (
        prepend specializes = </BaseRobot>
    )
    {
        double3 xformOp:translate = (0, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        over "Body"
        {
            double size = 4

            color3f[] primvars:displayColor = [
                (0.9, 0.2, 0.1)
            ]
        }
    }
}
USDA


# ============================================================
# PYTHON
# ============================================================

cat > "$LESSON/04_specializes.py" <<'PYTHON'
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
PYTHON


echo
echo "Lesson 11 created:"
echo
echo "  $LESSON/main.usda"
echo "  $LESSON/04_specializes.py"
echo
