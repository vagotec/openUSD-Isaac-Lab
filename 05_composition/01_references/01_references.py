# Documentation: 05_01 - References
# Goal: Understand reusable assets through USD references.
# Key concepts:
# - Reference: Composes prim data from another asset.
# - Asset path: Locates an external USD layer.
# - Prim path: Selects a prim inside the referenced asset.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 01 references example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "07_references/"
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


print()
print("========================================")
print("REFERENCE EXAMPLE")
print("========================================")
print()

for prim in stage.Traverse():
    print(
        prim.GetPath(),
        "type =",
        prim.GetTypeName()
    )

print()
print("Robot_A and Robot_B reference")
print("the same external robot.usda asset.")
print()
