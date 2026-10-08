#!/usr/bin/env bash
# Documentation: 04_01 - Layers
# Goal: Understand how USD stores opinions in layers.
# Key concepts demonstrated by the generated lesson:
# - Layer: Stores authored USD scene descriptions.
# - Root layer: Main layer used to open a stage.
# - SubLayer: Contributes opinions to a layer stack.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 04 01 create layers.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/04_layers"

mkdir -p "$LESSON"

# ============================================================
# Layer 1: robot.usda
#
# Contains the actual robot geometry.
# ============================================================

cat > "$LESSON/robot.usda" <<'USDA'
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
# Layer 2: main.usda
#
# This is the root layer.
# It includes robot.usda as a SUBLAYER.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    subLayers = [
        @robot.usda@
    ]
)
USDA


# ============================================================
# Python: inspect the Layer Stack
# ============================================================

cat > "$LESSON/01_layers.py" <<'PYTHON'
import omni


stage = omni.usd.get_context().get_stage()

if stage is None:
    raise RuntimeError("No Stage is currently open in Isaac Sim.")


print()
print("=== ROOT LAYER ===")

print(
    stage.GetRootLayer().identifier
)


print()
print("=== LAYER STACK ===")

for layer in stage.GetLayerStack():

    print(
        layer.identifier
    )


print()
print("=== PRIMS ===")

for prim in stage.Traverse():

    print(
        prim.GetPath()
    )
PYTHON


echo
echo "Lesson 05 created:"
echo
echo "  $LESSON/main.usda"
echo "  $LESSON/robot.usda"
echo "  $LESSON/01_layers.py"
echo
