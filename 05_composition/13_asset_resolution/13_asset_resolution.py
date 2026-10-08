# Documentation: 05_13 - Asset Resolution
# Goal: Understand how external USD asset paths are resolved.
# Key concepts:
# - Asset resolver: Resolves an asset path to a resource.
# - Relative path: Resolved against the containing layer.
# - Reference: Connects an external asset to the scene.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 13 asset resolution example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
