#!/usr/bin/env bash
# Documentation: 04_01 - Layers
# Goal: Understand how USD stores opinions in layers.
# Key concepts demonstrated by the generated lesson:
# - Layer: Stores authored USD scene descriptions.
# - Root layer: Main layer used to open a stage.
# - SubLayer: Contributes opinions to a layer stack.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 04 01 fix layers vscode.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/04_layers"

# Create a NEW corrected Python file.
cat > "$LESSON/01_layers_vscode.py" <<'PYTHON'
import omni
from pxr import Usd


# ============================================================
# 1. USD file that we want Isaac Sim to open
# ============================================================

USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "04_layers/main.usda"
)


# ============================================================
# 2. Open main.usda in Isaac Sim
#
# IMPORTANT:
# This is different from our previous version.
#
# get_stage() only returns the currently opened Stage.
#
# open_stage() actually OPENS our USD file.
# ============================================================

context = omni.usd.get_context()

success = context.open_stage(USD_FILE)

if not success:
    raise RuntimeError(
        f"Could not open USD Stage: {USD_FILE}"
    )


# ============================================================
# 3. Get the newly opened Stage
# ============================================================

stage = context.get_stage()

if stage is None:
    raise RuntimeError("No Stage available after opening USD file.")


# ============================================================
# 4. Show Root Layer
# ============================================================

print()
print("========================================")
print("ROOT LAYER")
print("========================================")

print(
    stage.GetRootLayer().identifier
)


# ============================================================
# 5. Show Layer Stack
# ============================================================

print()
print("========================================")
print("LAYER STACK")
print("========================================")

for layer in stage.GetLayerStack():

    print(
        layer.identifier
    )


# ============================================================
# 6. Show composed Prim hierarchy
# ============================================================

print()
print("========================================")
print("COMPOSED PRIMS")
print("========================================")

for prim in stage.Traverse():

    print(
        prim.GetPath(),
        "type =",
        prim.GetTypeName()
    )


print()
print("========================================")
print("Lesson 05 loaded successfully.")
print("========================================")
PYTHON


echo
echo "Corrected Lesson 05 created:"
echo
echo "  $LESSON/01_layers_vscode.py"
echo
echo "Run this file with:"
echo "  Isaac Sim VS Code Edition -> Run"
echo
