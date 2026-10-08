#!/usr/bin/env bash
# Documentation: 05_06 - LIVRPS
# Goal: Understand USD composition strength ordering.
# Key concepts demonstrated by the generated lesson:
# - LIVRPS: Local, Inherits, Variants, References, Payloads, Specializes.
# - Local opinions: Strongest category in this ordering.
# - Specializes: Weakest category in this ordering.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 06 create livrps.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/06_livrps"

mkdir -p "$LESSON"

# ============================================================
# USDA
#
# RobotClass:
#     Body size = 2
#
# Robot inherits RobotClass.
#
# But Robot also has a LOCAL opinion:
#     Body size = 4
#
# Local opinion wins.
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
)

class Xform "RobotClass"
{
    def Cube "Body"
    {
        double size = 2

        color3f[] primvars:displayColor = [
            (0.2, 0.5, 0.9)
        ]
    }
}


def Xform "World"
{
    def Xform "Robot" (
        prepend inherits = </RobotClass>
    )
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
# Python
# ============================================================

cat > "$LESSON/06_livrps.py" <<'PYTHON'
import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "13_livrps/"
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
print("LIVRPS")
print("========================================")

print()
print("Inherited opinion:")
print("size = 2")
print("color = blue")

print()
print("Local opinion:")
print("size = 4")
print("color = red")

print()
print("FINAL COMPOSED RESULT:")

print()
print("size:")
print(body.GetSizeAttr().Get())

print()
print("color:")
print(body.GetDisplayColorAttr().Get())


print()
print("========================================")
print("PRIM STACK")
print("========================================")

for prim_spec in body_prim.GetPrimStack():

    print()
    print("Layer:")
    print(prim_spec.layer.identifier)

    print("Path:")
    print(prim_spec.path)

    print("Specifier:")
    print(prim_spec.specifier)


print()
print("========================================")
PYTHON


echo
echo "Lesson 13 created:"
echo
echo "  $LESSON/main.usda"
echo "  $LESSON/06_livrps.py"
echo
