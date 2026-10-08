# Documentation: 03_04 - Visibility and Purpose
# Goal: Understand visibility and intended rendering purpose.
# Key concepts:
# - visibility: Controls whether an object is visible.
# - purpose: Classifies render, proxy, or guide geometry.
# - ComputeVisibility: Evaluates inherited visibility.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 04 visibility purpose example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
