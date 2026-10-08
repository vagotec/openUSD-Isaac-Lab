#!/usr/bin/env bash
# Documentation: 05_05 - Prim Stack
# Goal: Inspect all prim specifications contributing to a prim.
# Key concepts demonstrated by the generated lesson:
# - Prim stack: Ordered specifications composing one prim.
# - PrimSpec: Authored description of a prim in a layer.
# - Composition: Combines the prim stack into a result.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 05 create prim stack.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/05_prim_stack"

mkdir -p "$LESSON"

# ============================================================
# 1. WEAKER LAYER
# ============================================================

cat > "$LESSON/base.usda" <<'USDA'
#usda 1.0

def Xform "World"
{
    def Xform "Robot"
    {
        def Cube "Body"
        {
            double size = 2

            color3f[] primvars:displayColor = [
                (0.2, 0.5, 0.9)
            ]
        }
    }
}
USDA


# ============================================================
# 2. STRONGER LAYER
#
# Adds different opinions to the SAME Prim.
# ============================================================

cat > "$LESSON/override.usda" <<'USDA'
#usda 1.0

over "World"
{
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
}
USDA


# ============================================================
# 3. ROOT LAYER
#
# Earlier sublayer = stronger.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    subLayers = [
        @override.usda@,
        @base.usda@
    ]
)
USDA


# ============================================================
# 4. PYTHON
#
# Inspect:
#
# Layer Stack
# Prim Stack
# Final composed Prim
# ============================================================

cat > "$LESSON/05_prim_stack.py" <<'PYTHON'
import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "12_prim_stack/"
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
# Find composed Prim
# ------------------------------------------------------------

body_prim = stage.GetPrimAtPath(
    "/World/Robot/Body"
)

if not body_prim.IsValid():
    raise RuntimeError(
        "/World/Robot/Body not found."
    )

body = UsdGeom.Cube(body_prim)


# ------------------------------------------------------------
# 1. LAYER STACK
# ------------------------------------------------------------

print()
print("========================================")
print("1. LAYER STACK")
print("========================================")

for layer in stage.GetLayerStack():
    print(layer.identifier)


# ------------------------------------------------------------
# 2. PRIM STACK
#
# Which PrimSpecs contribute opinions
# to /World/Robot/Body?
# ------------------------------------------------------------

print()
print("========================================")
print("2. PRIM STACK")
print("========================================")

for prim_spec in body_prim.GetPrimStack():

    print()
    print("Layer:")
    print(prim_spec.layer.identifier)

    print("Prim path:")
    print(prim_spec.path)

    print("Specifier:")
    print(prim_spec.specifier)


# ------------------------------------------------------------
# 3. FINAL COMPOSED RESULT
# ------------------------------------------------------------

print()
print("========================================")
print("3. COMPOSED RESULT")
print("========================================")

print()
print("Prim:")
print(body_prim.GetPath())

print()
print("Type:")
print(body_prim.GetTypeName())

print()
print("Final size:")
print(body.GetSizeAttr().Get())

print()
print("Final color:")
print(body.GetDisplayColorAttr().Get())

print()
print("========================================")
PYTHON


echo
echo "Lesson 12 created:"
echo
echo "  $LESSON/base.usda"
echo "  $LESSON/override.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/05_prim_stack.py"
echo
