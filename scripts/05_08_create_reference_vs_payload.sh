#!/usr/bin/env bash
# Documentation: 05_08 - References vs Payloads
# Goal: Compare immediate references with loadable payloads.
# Key concepts demonstrated by the generated lesson:
# - Reference: Includes reusable content in composition.
# - Payload: Allows selective loading of content.
# - Load rules: Control which payloads are included.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 08 create reference vs payload.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/08_reference_vs_payload"

mkdir -p "$LESSON"

# ============================================================
# 1. PAYLOAD ASSET
#
# P = Payload
# Body size = 2
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
        double size = 2

        color3f[] primvars:displayColor = [
            (0.2, 0.5, 0.9)
        ]
    }
}
USDA


# ============================================================
# 2. REFERENCE ASSET
#
# R = Reference
# Body size = 4
# ============================================================

cat > "$LESSON/reference_robot.usda" <<'USDA'
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
# 3. MAIN
#
# SAME Robot gets:
#
# Reference -> Body size = 4
# Payload   -> Body size = 2
#
# R > P
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
)

def Xform "World"
{
    def Xform "Robot" (
        prepend references = @reference_robot.usda@
        prepend payload = @payload_robot.usda@
    )
    {
    }
}
USDA


# ============================================================
# 4. PYTHON
# ============================================================

cat > "$LESSON/08_reference_vs_payload.py" <<'PYTHON'
import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "15_reference_vs_payload/"
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
print("REFERENCE vs PAYLOAD")
print("========================================")

print()
print("Payload opinion:")
print("size = 2")

print()
print("Reference opinion:")
print("size = 4")

print()
print("Final composed size:")
print(body.GetSizeAttr().Get())

print()
print("Expected:")
print("R > P")
print("Therefore size = 4")

print()
print("Payload loaded:")
robot = stage.GetPrimAtPath("/World/Robot")
print(robot.IsLoaded())

print()
print("========================================")
PYTHON


echo
echo "Lesson 15 created:"
echo "  $LESSON/payload_robot.usda"
echo "  $LESSON/reference_robot.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/08_reference_vs_payload.py"
