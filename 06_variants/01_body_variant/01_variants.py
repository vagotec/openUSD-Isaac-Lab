# Documentation: 06_01 - Variant Sets
# Goal: Understand selectable alternatives in USD assets.
# Key concepts:
# - VariantSet: Collection of named alternatives.
# - Variant: One selectable set of authored opinions.
# - Selection: Determines the active alternative.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 01 variants example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "06_variants/"
    "09_body_variant/"
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


# ------------------------------------------------------------
# Get Robot Prim
# ------------------------------------------------------------

robot = stage.GetPrimAtPath(
    "/World/Robot"
)

if not robot.IsValid():
    raise RuntimeError(
        "/World/Robot was not found."
    )


# ------------------------------------------------------------
# Get Variant Set
# ------------------------------------------------------------

body_type = robot.GetVariantSets().GetVariantSet(
    "bodyType"
)


print()
print("========================================")
print("VARIANT SET")
print("========================================")

print()
print("Variant Set:")
print("bodyType")

print()
print("Available variants:")

for name in body_type.GetVariantNames():
    print(" ", name)

print()
print("Current selection:")
print(body_type.GetVariantSelection())

print()
print("========================================")
