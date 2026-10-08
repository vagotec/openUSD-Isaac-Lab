#!/usr/bin/env bash
# Documentation: 04_02 - Layer Strength
# Goal: Understand stronger and weaker layer opinions.
# Key concepts demonstrated by the generated lesson:
# - Layer strength: Determines which authored opinion wins.
# - Opinion: A value or metadata statement in a layer.
# - Composition: Combines opinions into a scene.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 04 02 create layer strength.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/04_layers"

mkdir -p "$LESSON/06_layer_strength"

LAB="$LESSON/06_layer_strength"

# ============================================================
# 1. BASE LAYER
#
# Defines the robot.
# Body size = 2
# ============================================================

cat > "$LAB/robot.usda" <<'USDA'
#usda 1.0

def Xform "Robot"
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
USDA


# ============================================================
# 2. OVERRIDE LAYER
#
# Does NOT create a second Body.
#
# It adds stronger opinions to the EXISTING Prim:
#
#     /Robot/Body
#
# New opinion:
#
#     size = 4
# ============================================================

cat > "$LAB/robot_override.usda" <<'USDA'
#usda 1.0

over "Robot"
{
    over "Body"
    {
        double size = 4

        color3f[] primvars:displayColor = [
            (0.9, 0.2, 0.1)
        ]
    }
}
USDA


# ============================================================
# 3. ROOT LAYER
#
# IMPORTANT:
#
# In the subLayers list, the EARLIER entry is stronger.
#
# robot_override.usda therefore wins over robot.usda.
# ============================================================

cat > "$LAB/main.usda" <<'USDA'
#usda 1.0
(
    subLayers = [
        @robot_override.usda@,
        @robot.usda@
    ]
)
USDA


# ============================================================
# 4. PYTHON
#
# Open the Stage directly from VS Code / Isaac Sim.
# Then read the COMPOSED result.
# ============================================================

cat > "$LAB/02_layer_strength.py" <<'PYTHON'
import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "04_layers/"
    "06_layer_strength/"
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
# Get the ONE composed Body Prim
# ------------------------------------------------------------

body_prim = stage.GetPrimAtPath(
    "/Robot/Body"
)

if not body_prim.IsValid():
    raise RuntimeError(
        "Prim /Robot/Body was not found."
    )

body = UsdGeom.Cube(body_prim)


# ------------------------------------------------------------
# Read final composed value
# ------------------------------------------------------------

size = body.GetSizeAttr().Get()


print()
print("========================================")
print("LAYER STRENGTH")
print("========================================")
print()

print("Prim:")
print(body_prim.GetPath())

print()

print("Final composed size:")
print(size)

print()

print("Expected:")
print("robot.usda          -> size = 2")
print("robot_override.usda -> size = 4")
print()
print("RESULT              -> size = 4")

print()
print("========================================")
PYTHON


echo
echo "Lesson 06 created:"
echo
echo "  $LAB/robot.usda"
echo "  $LAB/robot_override.usda"
echo "  $LAB/main.usda"
echo "  $LAB/02_layer_strength.py"
echo
echo "Run:"
echo "  02_layer_strength.py"
echo "  with Isaac Sim VS Code Edition -> Run"
echo
