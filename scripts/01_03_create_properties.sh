#!/usr/bin/env bash
# Documentation: 01_03 - Properties
# Goal: Distinguish attributes from relationships.
# Key concepts demonstrated by the generated lesson:
# - Attribute: Stores typed data on a prim.
# - Relationship: Stores target paths to other objects.
# - Get: Reads a composed attribute value.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 01 03 create properties.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/01_basics/03_properties"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA
#
# Demonstrate:
# - Attributes
# - Relationships
# - Multiple relationship targets
# ============================================================

cat > "$LESSON/properties.usda" <<'USDA'
#usda 1.0
(
    defaultPrim = "World"
    upAxis = "Z"
)

def Xform "World"
{
    def Cube "Box_A"
    {
        double size = 2

        double3 xformOp:translate = (-3, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        color3f[] primvars:displayColor = [
            (0.2, 0.5, 0.9)
        ]

        rel target = </World/Box_B>

        rel connections = [
            </World/Box_B>,
            </World/Box_C>
        ]
    }

    def Cube "Box_B"
    {
        double size = 3

        color3f[] primvars:displayColor = [
            (0.9, 0.3, 0.2)
        ]
    }

    def Cube "Box_C"
    {
        double size = 1

        double3 xformOp:translate = (4, 0, 0)

        uniform token[] xformOpOrder = [
            "xformOp:translate"
        ]

        color3f[] primvars:displayColor = [
            (0.2, 0.8, 0.3)
        ]
    }
}
USDA


# ============================================================
# 2. PYTHON
#
# Automatically open the USD stage in Isaac Sim.
# ============================================================

cat > "$LESSON/03_properties.py" <<'PYTHON'
from pathlib import Path

import omni.usd
from pxr import UsdGeom


USD_FILE = Path(__file__).with_name("properties.usda")

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

box_a = stage.GetPrimAtPath("/World/Box_A")

if not box_a.IsValid():
    raise RuntimeError("Box_A not found")


print()
print("========================================")
print("CHAPTER 19 - PROPERTIES")
print("========================================")


# ------------------------------------------------------------
# 1. ATTRIBUTE
# ------------------------------------------------------------

size_attr = box_a.GetAttribute("size")

print()
print("1. ATTRIBUTE")
print("Name:", size_attr.GetName())
print("Type:", size_attr.GetTypeName())
print("Value:", size_attr.Get())


# ------------------------------------------------------------
# 2. RELATIONSHIP
# ------------------------------------------------------------

target_rel = box_a.GetRelationship("target")

print()
print("2. RELATIONSHIP")
print("Name:", target_rel.GetName())
print("Targets:", target_rel.GetTargets())


# ------------------------------------------------------------
# 3. MULTIPLE TARGETS
# ------------------------------------------------------------

connections_rel = box_a.GetRelationship("connections")

print()
print("3. MULTIPLE TARGETS")

for target in connections_rel.GetTargets():
    print("Target:", target)


# ------------------------------------------------------------
# 4. LIST ALL PROPERTIES
# ------------------------------------------------------------

print()
print("4. ALL PROPERTIES OF Box_A")

for prop in box_a.GetProperties():

    if prop.IsRelationship():
        kind = "Relationship"
    else:
        kind = "Attribute"

    print(
        prop.GetName(),
        "->",
        kind
    )


# ------------------------------------------------------------
# 5. FOLLOW A RELATIONSHIP
# ------------------------------------------------------------

print()
print("5. FOLLOW RELATIONSHIP")

for target_path in target_rel.GetTargets():

    target_prim = stage.GetPrimAtPath(target_path)

    if not target_prim.IsValid():
        continue

    cube = UsdGeom.Cube(target_prim)

    print("Target Prim:", target_prim.GetPath())
    print("Target Size:", cube.GetSizeAttr().Get())


print()
print("========================================")
print("CHAPTER 19 COMPLETED")
print("========================================")
PYTHON


echo
echo "Chapter 19 created:"
echo
echo "  $LESSON/properties.usda"
echo "  $LESSON/03_properties.py"
