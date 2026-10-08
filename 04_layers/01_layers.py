# Documentation: 04_01 - Layers
# Goal: Understand how USD stores opinions in layers.
# Key concepts:
# - Layer: Stores authored USD scene descriptions.
# - Root layer: Main layer used to open a stage.
# - SubLayer: Contributes opinions to a layer stack.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 01 layers example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni


stage = omni.usd.get_context().get_stage()

if stage is None:
    raise RuntimeError("No Stage is currently open in Isaac Sim.")


print()
print("=== ROOT LAYER ===")

print(
    stage.GetRootLayer().identifier
)


print()
print("=== LAYER STACK ===")

for layer in stage.GetLayerStack():

    print(
        layer.identifier
    )


print()
print("=== PRIMS ===")

for prim in stage.Traverse():

    print(
        prim.GetPath()
    )
