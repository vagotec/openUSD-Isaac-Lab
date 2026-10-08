#!/usr/bin/env bash
# Documentation: 05_13 - Asset Resolution
# Goal: Understand how external USD asset paths are resolved.
# Key concepts demonstrated by the generated lesson:
# - Asset resolver: Resolves an asset path to a resource.
# - Relative path: Resolved against the containing layer.
# - Reference: Connects an external asset to the scene.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 13 create asset resolution.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/13_asset_resolution"

mkdir -p "$LESSON/assets"

# ============================================================
# 1. External asset: gripper.usda
# ============================================================

cat > "$LESSON/assets/gripper.usda" <<'USDA'
#usda 1.0

# Goal:
# Define a reusable gripper asset in a separate USD file.

(
    # defaultPrim: Default entry point of this asset.
    defaultPrim = "Gripper"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"
)

# def: Defines a prim.
# Xform: Transformable parent for the gripper geometry.
def Xform "Gripper"
{
    # Cube: Geometry representing the left finger.
    def Cube "LeftFinger"
    {
        # double: 64-bit floating-point number.
        # size: Length of each cube edge.
        double size = 1

        # double3: Three coordinates (X, Y, Z).
        # xformOp:translate: Position of the finger.
        double3 xformOp:translate = (1, 1, 0.5)

        # uniform: Value does not vary over time.
        # token[]: Array of string-like identifiers.
        # xformOpOrder: Active transforms and their order.
        uniform token[] xformOpOrder = ["xformOp:translate"]

        # color3f[]: Array of RGB colors.
        # primvars:displayColor: Standard display color.
        color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
    }

    # Cube: Geometry representing the right finger.
    def Cube "RightFinger"
    {
        # Cube edge length.
        double size = 1

        # Position of the right finger.
        double3 xformOp:translate = (3, 1, 0.5)

        # Apply the translation operation.
        uniform token[] xformOpOrder = ["xformOp:translate"]

        # Orange display color.
        color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
    }
}
USDA

# ============================================================
# 2. Main scene: robot.usda
# ============================================================

cat > "$LESSON/robot.usda" <<'USDA'
#usda 1.0

# Goal:
# Reference an external gripper asset using a relative path.
# Understand how OpenUSD resolves asset paths.

(
    # defaultPrim: Entry point of the main scene.
    defaultPrim = "World"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"
)

# Xform: Root of the scene.
def Xform "World"
{
    # Xform: Transformable parent for the robot.
    def Xform "Robot"
    {
        # Gripper: Prim receiving the referenced asset.
        def Xform "Gripper" (
            # prepend: Add the reference to the composition list.
            # references: Composition arc to another USD layer.
            #
            # @...@: USD asset path syntax.
            # ./: Path relative to this USDA file.
            # assets/gripper.usda: External asset filename.
            # </Gripper>: Prim selected from the external asset.
            #
            # The referenced children become part of this prim.
            prepend references = @./assets/gripper.usda@</Gripper>
        )
        {
            # No local geometry is needed.
            # The referenced asset supplies both fingers.
        }
    }
}
USDA

# ============================================================
# 3. Python: inspect asset resolution
# ============================================================

cat > "$LESSON/13_asset_resolution.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import Ar, Sdf

# Use an absolute path for the Isaac Sim Python server.
LESSON_DIR = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "05_composition/13_asset_resolution"
)

USD_FILE = LESSON_DIR / "robot.usda"

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

# Open the main USD scene in Isaac Sim.
context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

# Get the layer that contains the authored reference.
root_layer = stage.GetRootLayer()

# Get the prim that receives the referenced geometry.
prim = stage.GetPrimAtPath("/World/Robot/Gripper")

if not prim.IsValid():
    raise RuntimeError("Gripper prim not found")

print("\n=== ASSET RESOLUTION ===")

print("\n1. ROOT LAYER")
print("Identifier:", root_layer.identifier)
print("Resolved path:", root_layer.realPath)

# Read the reference as authored in the root layer.
# The reference is stored in the prim's SdfPrimSpec.
prim_spec = root_layer.GetPrimAtPath(prim.GetPath())

if prim_spec is None:
    raise RuntimeError("Gripper prim specification not found")

references = prim_spec.referenceList.prependedItems

if len(references) != 1:
    raise RuntimeError("Expected exactly one prepended reference")

reference = references[0]
asset_path = reference.assetPath

print("\n2. AUTHORED REFERENCE")
print("Asset path:", asset_path)
print("Target prim:", reference.primPath)

# Anchor the relative path to the layer containing the reference.
# This is important: the VS Code working directory is irrelevant.
anchored_path = Sdf.ComputeAssetPathRelativeToLayer(
    root_layer,
    asset_path,
)

# Resolve the anchored path using OpenUSD's asset resolver.
resolver = Ar.GetResolver()
resolved_path = resolver.Resolve(anchored_path)

print("\n3. ASSET RESOLVER")
print("Anchored path:", anchored_path)
print("Resolved path:", resolved_path)

if not resolved_path:
    raise RuntimeError("Referenced asset could not be resolved")

# Verify that the referenced geometry is present in the scene.
print("\n4. COMPOSED GEOMETRY")

for name in ("LeftFinger", "RightFinger"):
    path = f"/World/Robot/Gripper/{name}"
    child = stage.GetPrimAtPath(path)

    if not child.IsValid():
        raise RuntimeError(f"Referenced prim not found: {path}")

    print(f"{name}: {child.GetTypeName()}")

print("\nExercise 29 completed.")
PYTHON

echo "Created:"
echo "  $LESSON/assets/gripper.usda"
echo "  $LESSON/robot.usda"
echo "  $LESSON/13_asset_resolution.py"
