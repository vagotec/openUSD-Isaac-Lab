# Documentation: 01_04 - Metadata
# Goal: Understand metadata attached to USD objects.
# Key concepts:
# - Metadata: Describes a prim or layer.
# - GetMetadata: Reads composed metadata.
# - SetMetadata: Authors metadata in an editable layer.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 04 metadata example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
