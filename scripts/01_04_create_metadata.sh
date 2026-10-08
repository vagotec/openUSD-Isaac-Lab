#!/usr/bin/env bash
# Documentation: 01_04 - Metadata
# Goal: Understand metadata attached to USD objects.
# Key concepts demonstrated by the generated lesson:
# - Metadata: Describes a prim or layer.
# - GetMetadata: Reads composed metadata.
# - SetMetadata: Authors metadata in an editable layer.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 01 04 create metadata.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/01_basics/04_metadata"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA - Metadata examples
# ============================================================

cat > "$LESSON/metadata.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Z"
    metersPerUnit = 1
    timeCodesPerSecond = 24
    documentation = "OpenUSD Chapter 20 - Metadata"
)

def Xform "World"
{
    def Cube "Box" (
        kind = "component"
        documentation = "A simple cube for learning USD metadata."
    )
    {
        double size = 2 (
            displayName = "Cube Size"
            documentation = "The side length of the cube."
        )

        double3 xformOp:translate = (1, 1, 1)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        color3f[] primvars:displayColor = [
            (0.2, 0.5, 0.9)
        ]
    }
}
USDA


# ============================================================
# 2. PYTHON - Inspect metadata
# ============================================================

cat > "$LESSON/04_metadata.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import UsdGeom


# Use an absolute project path because the Isaac Sim
# VS Code Python server does not preserve __file__.

USD_FILE = (
    Path.home()
    / "projects"
    / "openUSD-Isaac-Lab"
    / "01_basics"
    / "20_metadata"
    / "metadata.usda"
)

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

box = stage.GetPrimAtPath("/World/Box")

if not box.IsValid():
    raise RuntimeError("Box not found")


print()
print("========================================")
print("CHAPTER 20 - METADATA")
print("========================================")


# ------------------------------------------------------------
# 1. Stage metadata
# ------------------------------------------------------------

print()
print("1. STAGE METADATA")

print("Up Axis:", UsdGeom.GetStageUpAxis(stage))
print("Meters Per Unit:", UsdGeom.GetStageMetersPerUnit(stage))
print("Time Codes Per Second:", stage.GetTimeCodesPerSecond())

print(
    "Documentation:",
    stage.GetRootLayer().GetDocumentation()
)


# ------------------------------------------------------------
# 2. Prim metadata
# ------------------------------------------------------------

print()
print("2. PRIM METADATA")

print("Prim:", box.GetPath())
print("Kind:", box.GetMetadata("kind"))
print("Documentation:", box.GetDocumentation())


# ------------------------------------------------------------
# 3. Property metadata
# ------------------------------------------------------------

print()
print("3. PROPERTY METADATA")

size_attr = box.GetAttribute("size")

print("Attribute:", size_attr.GetName())
print("Value:", size_attr.Get())
print("Display Name:", size_attr.GetDisplayName())
print("Documentation:", size_attr.GetDocumentation())


# ------------------------------------------------------------
# 4. Compare attribute and metadata
# ------------------------------------------------------------

print()
print("4. ATTRIBUTE vs METADATA")

print("Attribute size:", size_attr.Get())
print("Metadata kind:", box.GetMetadata("kind"))


# ------------------------------------------------------------
# 5. List authored prim metadata
# ------------------------------------------------------------

print()
print("5. AUTHORED PRIM METADATA")

for key, value in box.GetAllAuthoredMetadata().items():
    print(f"{key}: {value}")


print()
print("========================================")
print("CHAPTER 20 COMPLETED")
print("========================================")
PYTHON

echo
echo "Chapter 20 created:"
echo "  $LESSON/metadata.usda"
echo "  $LESSON/04_metadata.py"
