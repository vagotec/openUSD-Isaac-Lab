#!/usr/bin/env bash
# Documentation: 05_02 - Payloads
# Goal: Understand deferred loading of referenced content.
# Key concepts demonstrated by the generated lesson:
# - Payload: Composition arc that supports load and unload.
# - Load: Includes payload content in the composed stage.
# - Unload: Excludes payload content without deleting the asset.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 05 02 create payload.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/05_composition/02_payload"

mkdir -p "$LESSON"

# ============================================================
# 1. ROBOT ASSET
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

        double3 xformOp:translate = (0, 0, 1)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        color3f[] primvars:displayColor = [
            (0.2, 0.5, 0.9)
        ]
    }

    def Sphere "Head"
    {
        double radius = 0.75

        double3 xformOp:translate = (0, 0, 3)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        color3f[] primvars:displayColor = [
            (0.9, 0.4, 0.1)
        ]
    }
}
USDA


# ============================================================
# 2. MAIN SCENE
#
# NEW:
# Instead of "references" we use "payload".
# ============================================================

cat > "$LESSON/main.usda" <<'USDA'
#usda 1.0

def Xform "World"
{
    def Xform "Robot" (
        prepend payload = @robot.usda@
    )
    {
    }
}
USDA


# ============================================================
# 3. PYTHON
#
# Open Stage and demonstrate:
#
# LOAD   -> Body + Head available
# UNLOAD -> payload content disappears
# LOAD   -> content returns
# ============================================================

cat > "$LESSON/02_payload.py" <<'PYTHON'
import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "08_payload/"
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


robot = stage.GetPrimAtPath("/World/Robot")

if not robot.IsValid():
    raise RuntimeError(
        "/World/Robot was not found."
    )


# ------------------------------------------------------------
# Initial state
# ------------------------------------------------------------

print()
print("========================================")
print("PAYLOAD")
print("========================================")

print()
print("Has payload:")
print(robot.HasPayload())

print()
print("Payload loaded:")
print(robot.IsLoaded())


# ------------------------------------------------------------
# Show loaded hierarchy
# ------------------------------------------------------------

print()
print("PRIMS WHILE LOADED:")

for prim in stage.Traverse():
    print(prim.GetPath())


# ------------------------------------------------------------
# UNLOAD
#
# The Prim /World/Robot remains,
# but the content coming from robot.usda is unloaded.
# ------------------------------------------------------------

print()
print("----------------------------------------")
print("UNLOAD PAYLOAD")
print("----------------------------------------")

robot.Unload()

print()
print("Payload loaded:")
print(robot.IsLoaded())

print()
print("PRIMS AFTER UNLOAD:")

for prim in stage.Traverse():
    print(prim.GetPath())


# ------------------------------------------------------------
# LOAD AGAIN
# ------------------------------------------------------------

print()
print("----------------------------------------")
print("LOAD PAYLOAD AGAIN")
print("----------------------------------------")

robot.Load()

print()
print("Payload loaded:")
print(robot.IsLoaded())

print()
print("PRIMS AFTER LOAD:")

for prim in stage.Traverse():
    print(prim.GetPath())


print()
print("========================================")
print("Lesson 08 completed.")
print("========================================")
PYTHON


echo
echo "Lesson 08 created:"
echo
echo "  $LESSON/robot.usda"
echo "  $LESSON/main.usda"
echo "  $LESSON/02_payload.py"
echo
