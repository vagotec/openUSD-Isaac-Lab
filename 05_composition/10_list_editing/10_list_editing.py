# Documentation: 05_10 - List Editing
# Goal: Understand how USD list operations affect composition.
# Key concepts:
# - prepend: Adds items before weaker list contributions.
# - delete: Removes matching items from weaker lists.
# - Reference list: Stores composition references on a prim.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 10 list editing example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

from pathlib import Path

import omni.usd
from pxr import Sdf, Usd

PROJECT = Path.home() / "projects/openUSD-Isaac-Lab"
USD_FILE = PROJECT / "05_composition/10_list_editing/main.usda"

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Cannot open {USD_FILE}")

stage = context.get_stage()
prim = stage.GetPrimAtPath("/World/Object")

if not prim.IsValid():
    raise RuntimeError("Missing /World/Object")

print("\n=== CHAPTER 23: LIST EDITING ===")
print("Composed type:", prim.GetTypeName())

root_spec = stage.GetRootLayer().GetPrimAtPath("/World/Object")
print("References:", root_spec.referenceList.prependedItems)

# Inspect list editing without modifying the visible stage.
# A separate in-memory layer demonstrates explicit reference removal.
layer = Sdf.Layer.CreateAnonymous("list_editing_demo.usda")
spec = Sdf.CreatePrimInLayer(layer, "/Example")

reference = Sdf.Reference("./example.usda", "/Example")

spec.referenceList.prependedItems = [reference]
print("Before removal:", spec.referenceList.prependedItems)

spec.referenceList.prependedItems = []
print("After removal:", spec.referenceList.prependedItems)

assert prim.GetTypeName() == "Cube"
assert len(spec.referenceList.prependedItems) == 0

print("PASS: Chapter 23")
