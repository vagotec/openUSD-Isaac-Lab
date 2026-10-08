#!/usr/bin/env bash
# Documentation: 05_03 - Inherits
# Goal: Understand reusable inherited opinions.
# Key concepts demonstrated by the generated lesson:
# - inherits: Composition arc for shared opinions.
# - Class prim: Common source of inherited properties.
# - Composition strength: Determines overriding opinions.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 03 create inherits.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/03_inherits"

mkdir -p "$LESSON"

# ============================================================
# USDA
#
# /RobotClass is our common source of opinions.
#
# Robot_A and Robot_B inherit from /RobotClass.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
)

class Xform "RobotClass"
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
    def Xform "Robot_A" (
        prepend inherits = </RobotClass>
    )
    {
        double3 xformOp:translate = (-3, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]
    }


    def Xform "Robot_B" (
        prepend inherits = </RobotClass>
    )
    {
        double3 xformOp:translate = (3, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]
    }
}
USDA


# ============================================================
# PYTHON
# ============================================================

cat > "$LESSON/03_inherits.py" <<'PYTHON'
import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "10_inherits/"
    "main.usda"
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


robot_a = stage.GetPrimAtPath("/World/Robot_A")
robot_b = stage.GetPrimAtPath("/World/Robot_B")


print()
print("========================================")
print("INHERITS")
print("========================================")

print()
print("Robot_A:")
print(robot_a.GetPath())

print("Has authored inherits:")
print(robot_a.HasAuthoredInherits())

print()
print("Robot_B:")
print(robot_b.GetPath())

print("Has authored inherits:")
print(robot_b.HasAuthoredInherits())


print()
print("COMPOSED PRIMS:")
print()

for prim in stage.Traverse():
    print(prim.GetPath())

print()
print("========================================")
PYTHON


echo
echo "Lesson 10 created:"
echo
echo "  $LESSON/main.usda"
echo "  $LESSON/03_inherits.py"
echo
