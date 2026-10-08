# Documentation: 01_03 - Properties
# Goal: Distinguish attributes from relationships.
# Key concepts:
# - Attribute: Stores typed data on a prim.
# - Relationship: Stores target paths to other objects.
# - Get: Reads a composed attribute value.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 03 properties example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

from pathlib import Path

import omni.usd
from pxr import UsdGeom


USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "01_basics/03_properties/properties.usda"
)

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
