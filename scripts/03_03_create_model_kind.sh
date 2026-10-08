#!/usr/bin/env bash
# Documentation: 03_03 - Model and Kind
# Goal: Understand model classification and valid model hierarchy.
# Key concepts demonstrated by the generated lesson:
# - kind: Metadata describing a model's role.
# - group: Model that contains other models.
# - component: Independently meaningful model.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 03 03 create model kind.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/03_hierarchy/03_model_kind"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA
# ============================================================

cat > "$LESSON/model_kind.usda" <<'USDA'
#usda 1.0

# Goal:
# Understand how kind classifies models and their components.
# Create a gripper containing two fingers.

(
    # defaultPrim: Entry point of this USD asset.
    defaultPrim = "World"

    # upAxis: Defines the vertical axis.
    upAxis = "Z"
)

# def: Defines a prim.
# Xform: Groups objects and supports transformations.
# World: Root prim of our scene.
# kind: Model classification metadata.
# group: A model that contains other models.
def Xform "World" (
    kind = "group"
)
{
    # Gripper is a model containing two fingers.
    # kind: Metadata describing the model's role.
    # component: Marks Gripper as an independent model.
    def Xform "Gripper" (
        kind = "component"
    )
    {
        # LeftFinger is a part of the Gripper model.
        # subcomponent: Identifies a part inside a component.
        # Cube: Defines visible cube geometry.
        def Cube "LeftFinger" (
            kind = "subcomponent"
        )
        {
            # double: 64-bit floating-point data type.
            # size: Length of each cube edge.
            double size = 1

            # double3: Three double values for X, Y and Z.
            # xformOp:translate: Positions the cube center.
            double3 xformOp:translate = (1, 1, 0.5)

            # uniform: Attribute is not intended to vary over time.
            # token[]: Array of token values.
            # xformOpOrder: Defines active transforms and their order.
            uniform token[] xformOpOrder = ["xformOp:translate"]

            # color3f[]: Array of RGB colors.
            # primvars:displayColor: Standard display color primvar.
            color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
        }

        # RightFinger is another part of the same model.
        # subcomponent: Identifies a part of Gripper.
        def Cube "RightFinger" (
            kind = "subcomponent"
        )
        {
            # Cube edge length.
            double size = 1

            # Position the second finger along the X axis.
            double3 xformOp:translate = (3, 1, 0.5)

            # Apply the translation operation.
            uniform token[] xformOpOrder = ["xformOp:translate"]

            # Give the second finger an orange display color.
            color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
        }
    }
}
USDA

# ============================================================
# 2. PYTHON
# ============================================================

cat > "$LESSON/03_model_kind.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import Usd

# Absolute path is required by the Isaac Sim VS Code Python server.
USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "03_hierarchy/03_model_kind/model_kind.usda"
)

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

# Open the USDA file in Isaac Sim.
context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

print("\n=== MODEL AND KIND ===")

# Inspect the model hierarchy.
paths = [
    "/World",
    "/World/Gripper",
    "/World/Gripper/LeftFinger",
    "/World/Gripper/RightFinger",
]

for path in paths:
    prim = stage.GetPrimAtPath(path)

    if not prim.IsValid():
        raise RuntimeError(f"Prim not found: {path}")

    # ModelAPI provides access to model metadata.
    model = Usd.ModelAPI(prim)

    print(f"\nPrim: {path}")
    print("Type:", prim.GetTypeName())
    print("Kind:", model.GetKind())
    print("Is Model:", prim.IsModel())
    print("Is Group:", prim.IsGroup())

print("\nExercise completed.")
PYTHON

echo "Created:"
echo "  $LESSON/model_kind.usda"
echo "  $LESSON/03_model_kind.py"
