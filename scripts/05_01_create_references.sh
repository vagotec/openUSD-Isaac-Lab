#!/usr/bin/env bash
# Documentation: 05_01 - References
# Goal: Understand reusable assets through USD references.
# Key concepts demonstrated by the generated lesson:
# - Reference: Composes prim data from another asset.
# - Asset path: Locates an external USD layer.
# - Prim path: Selects a prim inside the referenced asset.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 01 create references.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/01_references"

mkdir -p "$LESSON"

# ============================================================
# 1. ROBOT ASSET
#
# This file describes ONE reusable robot asset.
# ============================================================

cat > "$LESSON/robot.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "Robot"
)

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

        color3f[] primvars:displayColor = [
            (0.9, 0.4, 0.1)
        ]
    }
}
USDA


# ============================================================
# 2. MAIN SCENE
#
# Two Prims reference the SAME robot.usda asset.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0

def Xform "World"
{
    def Xform "Robot_A" (
        prepend references = @robot.usda@
    )
    {
        double3 xformOp:translate = (-3, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]
    }

    def Xform "Robot_B" (
        prepend references = @robot.usda@
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
# 3. PYTHON
#
# Open main.usda automatically from VS Code.
# ============================================================

cat > "$LESSON/01_references.py" <<'PYTHON'
import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "07_references/"
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


print()
print("========================================")
print("REFERENCE EXAMPLE")
print("========================================")
print()

for prim in stage.Traverse():
    print(
        prim.GetPath(),
        "type =",
        prim.GetTypeName()
    )

print()
print("Robot_A and Robot_B reference")
print("the same external robot.usda asset.")
print()
PYTHON


echo
echo "Lesson 07 created:"
echo
echo "  $LESSON/robot.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/01_references.py"
echo
