# Documentation: 01_07 - Primvars
# Goal: Understand geometry-related primitive variables.
# Key concepts:
# - primvars: Namespace for geometry-related data.
# - displayColor: Standard display-color primvar.
# - Interpolation: Describes how primvar values map to geometry.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 07 primvars example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

from pathlib import Path

import omni.usd
from pxr import UsdGeom

USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "01_basics/07_primvars/primvars.usda"
)

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()
prim = stage.GetPrimAtPath("/World/Box")

if not prim.IsValid():
    raise RuntimeError("Prim /World/Box not found")

print("\n=== CHAPTER 22: NAMESPACES AND PRIMVARS ===")

# 1. Inspect all authored properties.
print("\n1. AUTHORED PROPERTIES")

for prop in prim.GetAuthoredProperties():
    print(" ", prop.GetName())

# 2. Inspect properties in the primvars namespace.
print("\n2. PRIMVARS NAMESPACE")

for prop in prim.GetAuthoredPropertiesInNamespace("primvars"):
    print(" ", prop.GetName())

# 3. Read the color through PrimvarsAPI.
print("\n3. PRIMVARS API")

primvars_api = UsdGeom.PrimvarsAPI(prim)
color = primvars_api.GetPrimvar("displayColor")

if not color:
    raise RuntimeError("Primvar displayColor not found")

print("Name:", color.GetName())
print("Value:", color.Get())
print("Interpolation:", color.GetInterpolation())

# 4. Compare with an ordinary attribute.
print("\n4. NORMAL ATTRIBUTE")

size = prim.GetAttribute("size")
print("Name:", size.GetName())
print("Value:", size.Get())

print("\nChapter 22 completed.")
