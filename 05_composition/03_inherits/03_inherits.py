# Documentation: 05_03 - Inherits
# Goal: Understand reusable inherited opinions.
# Key concepts:
# - inherits: Composition arc for shared opinions.
# - Class prim: Common source of inherited properties.
# - Composition strength: Determines overriding opinions.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 03 inherits example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "10_inherits/"
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


robot_a = stage.GetPrimAtPath("/World/Robot_A")
robot_b = stage.GetPrimAtPath("/World/Robot_B")


print()
print("========================================")
print("INHERITS")
print("========================================")

print()
print("Robot_A:")
print(robot_a.GetPath())

print("Has authored inherits:")
print(robot_a.HasAuthoredInherits())

print()
print("Robot_B:")
print(robot_b.GetPath())

print("Has authored inherits:")
print(robot_b.HasAuthoredInherits())


print()
print("COMPOSED PRIMS:")
print()

for prim in stage.Traverse():
    print(prim.GetPath())

print()
print("========================================")
