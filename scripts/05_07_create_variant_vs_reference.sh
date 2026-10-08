#!/usr/bin/env bash
# Documentation: 05_07 - Variants vs References
# Goal: Compare variant selection with external asset references.
# Key concepts demonstrated by the generated lesson:
# - VariantSet: Defines alternative authored opinions.
# - Variant selection: Chooses one alternative.
# - Reference: Composes content from another prim or asset.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 07 create variant vs reference.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/07_variant_vs_reference"

mkdir -p "$LESSON"

# ============================================================
# 1. REFERENCED ASSET
#
# Reference opinion:
# Body size = 2
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

        color3f[] primvars:displayColor = [
            (0.2, 0.5, 0.9)
        ]
    }
}
USDA


# ============================================================
# 2. MAIN
#
# Robot gets:
#
# R = Reference  -> size = 2
# V = Variant    -> size = 4
#
# V is stronger than R.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
)

def Xform "World"
{
    def Xform "Robot" (
        prepend references = @robot.usda@

        variants = {
            string bodyType = "large"
        }

        prepend variantSets = "bodyType"
    )
    {
        variantSet "bodyType" = {

            "large"
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
    }
}
USDA


# ============================================================
# 3. PYTHON
# ============================================================

cat > "$LESSON/07_variant_vs_reference.py" <<'PYTHON'
import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "14_variant_vs_reference/"
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


body_prim = stage.GetPrimAtPath(
    "/World/Robot/Body"
)

if not body_prim.IsValid():
    raise RuntimeError(
        "/World/Robot/Body not found."
    )

body = UsdGeom.Cube(body_prim)


print()
print("========================================")
print("VARIANT vs REFERENCE")
print("========================================")

print()
print("Reference opinion:")
print("size = 2")

print()
print("Variant opinion:")
print("size = 4")

print()
print("Final composed size:")
print(body.GetSizeAttr().Get())

print()
print("Expected:")
print("V > R")
print("Therefore size = 4")

print()
print("========================================")
PYTHON


echo
echo "Lesson 14 created:"
echo
echo "  $LESSON/robot.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/07_variant_vs_reference.py"
