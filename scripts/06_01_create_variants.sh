#!/usr/bin/env bash
# Documentation: 06_01 - Variant Sets
# Goal: Understand selectable alternatives in USD assets.
# Key concepts demonstrated by the generated lesson:
# - VariantSet: Collection of named alternatives.
# - Variant: One selectable set of authored opinions.
# - Selection: Determines the active alternative.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 06 01 create variants.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/06_variants/01_body_variant"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA WITH VARIANT SET
#
# Robot always exists.
# Body always exists.
#
# The Variant Set "bodyType" changes the size and color
# of the SAME Body Prim.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
)

def Xform "World"
{
    def Xform "Robot" (
        variants = {
            string bodyType = "small"
        }
        prepend variantSets = "bodyType"
    )
    {
        def Cube "Body"
        {
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

        variantSet "bodyType" = {

            "small"
            {
                over "Body"
                {
                    double size = 1.5

                    color3f[] primvars:displayColor = [
                        (0.2, 0.5, 0.9)
                    ]
                }
            }

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
# 2. PYTHON
#
# Open Stage and inspect the Variant Set.
# ============================================================

cat > "$LESSON/01_variants.py" <<'PYTHON'
import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "06_variants/"
    "09_body_variant/"
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
# Get Robot Prim
# ------------------------------------------------------------

robot = stage.GetPrimAtPath(
    "/World/Robot"
)

if not robot.IsValid():
    raise RuntimeError(
        "/World/Robot was not found."
    )


# ------------------------------------------------------------
# Get Variant Set
# ------------------------------------------------------------

body_type = robot.GetVariantSets().GetVariantSet(
    "bodyType"
)


print()
print("========================================")
print("VARIANT SET")
print("========================================")

print()
print("Variant Set:")
print("bodyType")

print()
print("Available variants:")

for name in body_type.GetVariantNames():
    print(" ", name)

print()
print("Current selection:")
print(body_type.GetVariantSelection())

print()
print("========================================")
PYTHON


echo
echo "Lesson 09 created:"
echo
echo "  $LESSON/main.usda"
echo "  $LESSON/01_variants.py"
echo
