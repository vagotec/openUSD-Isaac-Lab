# Documentation: 05_11 - Native Instancing
# Goal: Understand memory-efficient native USD instances.
# Key concepts:
# - instanceable: Enables instance sharing.
# - Prototype: Shared composed scene representation.
# - Instance: Prim using a shared prototype.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 11 instancing example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

from pathlib import Path

import omni.usd

# The Isaac Sim VS Code server does not preserve __file__.
USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "05_composition/11_instancing/main.usda"
)

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

# Open the scene in Isaac Sim.
context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

print("\n=== INSTANCE AND PROTOTYPE ===")

# Inspect each instance root.
for name in ("Cube_A", "Cube_B", "Cube_C"):
    prim = stage.GetPrimAtPath(f"/World/{name}")

    if not prim.IsValid():
        raise RuntimeError(f"Prim not found: {name}")

    print(f"\nPrim: {prim.GetPath()}")
    print("Type:", prim.GetTypeName())
    print("Instanceable:", prim.IsInstanceable())
    print("Is Instance:", prim.IsInstance())

    if prim.IsInstance():
        # Each instance points to a shared prototype.
        prototype = prim.GetPrototype()
        print("Prototype:", prototype.GetPath())

# Inspect the prototypes created by USD.
print("\nPROTOTYPES")

prototypes = stage.GetPrototypes()

print("Number of prototypes:", len(prototypes))

for prototype in prototypes:
    print("Prototype:", prototype.GetPath())

    # Prototype children contain the shared geometry.
    for child in prototype.GetChildren():
        print("  Child:", child.GetPath())
        print("  Type:", child.GetTypeName())

print("\nExercise 26.1 completed.")
