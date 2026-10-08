#!/usr/bin/env bash
# Documentation: 07_01 - Robot Hierarchy
# Goal: Represent a robot as a hierarchy of USD prims.
# Key concepts demonstrated by the generated lesson:
# - Robot root: Parent prim organizing robot components.
# - Transform hierarchy: Defines component placement.
# - Child prim: Represents a nested robot component.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 07 01 create robot hierarchy.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/07_robot/01_robot_hierarchy"

mkdir -p "$LESSON"

# ============================================================
# USDA
# ============================================================

cat > "$LESSON/robot.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Z"
)

def Xform "World"
{
    def Xform "Robot"
    {
        # ----------------------------------------------------
        # Robot base
        # ----------------------------------------------------

        def Cube "Base"
        {
            double size = 1

            float3 xformOp:scale = (2.5, 2.5, 0.5)
            double3 xformOp:translate = (0, 0, 0.25)

            uniform token[] xformOpOrder = [
                "xformOp:translate",
                "xformOp:scale"
            ]

            color3f[] primvars:displayColor = [
                (0.3, 0.3, 0.3)
            ]
        }


        # ----------------------------------------------------
        # Arm parent
        # ----------------------------------------------------

        def Xform "Arm"
        {
            double3 xformOp:translate = (0, 0, 0.5)

            uniform token[] xformOpOrder = [
                "xformOp:translate"
            ]


            # ------------------------------------------------
            # Upper arm
            # ------------------------------------------------

            def Cube "UpperArm"
            {
                double size = 1

                float3 xformOp:scale = (0.4, 0.4, 3)
                double3 xformOp:translate = (0, 0, 1.5)

                uniform token[] xformOpOrder = [
                    "xformOp:translate",
                    "xformOp:scale"
                ]

                color3f[] primvars:displayColor = [
                    (0.2, 0.5, 0.9)
                ]
            }


            # ------------------------------------------------
            # Forearm
            # ------------------------------------------------

            def Cube "Forearm"
            {
                double size = 1

                float3 xformOp:scale = (0.3, 0.3, 2)
                double3 xformOp:translate = (0, 0, 4)

                uniform token[] xformOpOrder = [
                    "xformOp:translate",
                    "xformOp:scale"
                ]

                color3f[] primvars:displayColor = [
                    (0.9, 0.4, 0.1)
                ]
            }
        }
    }
}
USDA


# ============================================================
# PYTHON
#
# Open the robot automatically from VS Code.
# ============================================================

cat > "$LESSON/01_robot_hierarchy.py" <<'PYTHON'
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
PYTHON


echo
echo "Lesson 17 created:"
echo
echo "  $LESSON/robot.usda"
echo "  $LESSON/01_robot_hierarchy.py"
