# Documentation: 03_03 - Model and Kind
# Goal: Understand model classification and valid model hierarchy.
# Key concepts:
# - kind: Metadata describing a model's role.
# - group: Model that contains other models.
# - component: Independently meaningful model.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 03 model kind example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
