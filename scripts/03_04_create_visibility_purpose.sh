#!/usr/bin/env bash
# Documentation: 03_04 - Visibility and Purpose
# Goal: Understand visibility and intended rendering purpose.
# Key concepts demonstrated by the generated lesson:
# - visibility: Controls whether an object is visible.
# - purpose: Classifies render, proxy, or guide geometry.
# - ComputeVisibility: Evaluates inherited visibility.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 03 04 create visibility purpose.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/03_hierarchy/04_visibility_purpose"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA
# ============================================================

cat > "$LESSON/visibility_purpose.usda" <<'USDA'
#usda 1.0

# Goal:
# Understand how visibility and purpose control
# the presentation of geometry in OpenUSD.

(
    # defaultPrim: Entry point of this USD asset.
    defaultPrim = "World"

    # upAxis: Defines the vertical axis.
    upAxis = "Z"
)

# Xform: Groups objects and supports transformations.
# World: Root prim of the scene.
def Xform "World"
{
    # Group both fingers under one parent.
    def Xform "Gripper"
    {
        # Cube: Visible geometry representing the left finger.
        def Cube "LeftFinger"
        {
            # double: 64-bit floating-point value.
            # size: Cube edge length.
            double size = 1

            # double3: Three coordinates (X, Y, Z).
            # xformOp:translate: Position of the cube center.
            double3 xformOp:translate = (1, 1, 0.5)

            # uniform: Not intended to vary over time.
            # token[]: Array of string-like identifiers.
            # xformOpOrder: Active transforms and their order.
            uniform token[] xformOpOrder = ["xformOp:translate"]

            # token: String-like identifier.
            # visibility: Controls whether geometry is visible.
            # inherited: Use the visibility of the parent hierarchy.
            token visibility = "inherited"

            # purpose: Defines the intended use of the geometry.
            # default: Normal geometry.
            uniform token purpose = "default"

            # color3f[]: Array of RGB colors.
            # primvars:displayColor: Standard display color.
            color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
        }

        # Cube: Geometry representing the right finger.
        def Cube "RightFinger"
        {
            # Set the cube edge length.
            double size = 1

            # Position the cube to the right of LeftFinger.
            double3 xformOp:translate = (3, 1, 0.5)

            # Activate the translation operation.
            uniform token[] xformOpOrder = ["xformOp:translate"]

            # invisible: Hide this cube.
            token visibility = "invisible"

            # default: Normal geometry.
            uniform token purpose = "default"

            # Orange display color.
            color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
        }
    }
}
USDA

# ============================================================
# 2. PYTHON
# ============================================================

cat > "$LESSON/04_visibility_purpose.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import UsdGeom

# Use an absolute path for the Isaac Sim VS Code Python server.
USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "03_hierarchy/04_visibility_purpose/visibility_purpose.usda"
)

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

# Open the USDA file in Isaac Sim.
context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

print("\n=== VISIBILITY AND PURPOSE ===")

# Inspect both fingers.
for name in ("LeftFinger", "RightFinger"):
    path = f"/World/Gripper/{name}"
    prim = stage.GetPrimAtPath(path)

    if not prim.IsValid():
        raise RuntimeError(f"Prim not found: {path}")

    # Imageable provides access to visibility and purpose.
    imageable = UsdGeom.Imageable(prim)

    print(f"\nPrim: {path}")
    print("Visibility:", imageable.GetVisibilityAttr().Get())
    print("Computed Visibility:", imageable.ComputeVisibility())
    print("Purpose:", imageable.GetPurposeAttr().Get())

print("\nExercise completed.")
PYTHON

echo "Created:"
echo "  $LESSON/visibility_purpose.usda"
echo "  $LESSON/04_visibility_purpose.py"
