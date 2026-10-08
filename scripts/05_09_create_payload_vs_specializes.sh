#!/usr/bin/env bash
# Documentation: 05_09 - Payloads vs Specializes
# Goal: Compare loading composition with specialization.
# Key concepts demonstrated by the generated lesson:
# - Payload: Loadable composition arc.
# - Specializes: Supplies fallback opinions.
# - Composition arc: Connects authored scene descriptions.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 09 create payload vs specializes.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/09_payload_vs_specializes"

mkdir -p "$LESSON"

# ============================================================
# 1. PAYLOAD ASSET
#
# P = Payload
# Body size = 4
# ============================================================

cat > "$LESSON/payload_robot.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "Robot"
)

def Xform "Robot"
{
    def Cube "Body"
    {
        double size = 4

        color3f[] primvars:displayColor = [
            (0.9, 0.2, 0.1)
        ]
    }
}
USDA


# ============================================================
# 2. MAIN
#
# BaseRobot contributes:
#     S = Specializes
#     Body size = 2
#
# Robot also gets:
#     P = Payload
#     Body size = 4
#
# P > S
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
)

class Xform "BaseRobot"
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
        prepend specializes = </BaseRobot>
        prepend payload = @payload_robot.usda@
    )
    {
    }
}
USDA


# ============================================================
# 3. PYTHON
# ============================================================

cat > "$LESSON/09_payload_vs_specializes.py" <<'PYTHON'
import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "16_payload_vs_specializes/"
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


robot = stage.GetPrimAtPath(
    "/World/Robot"
)

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
print("PAYLOAD vs SPECIALIZES")
print("========================================")

print()
print("Specializes opinion:")
print("size = 2")

print()
print("Payload opinion:")
print("size = 4")

print()
print("Final composed size:")
print(body.GetSizeAttr().Get())

print()
print("Expected:")
print("P > S")
print("Therefore size = 4")

print()
print("Payload loaded:")
print(robot.IsLoaded())

print()
print("========================================")
PYTHON


echo
echo "Lesson 16 created:"
echo
echo "  $LESSON/payload_robot.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/09_payload_vs_specializes.py"
