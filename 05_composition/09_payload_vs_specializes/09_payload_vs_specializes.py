# Documentation: 05_09 - Payloads vs Specializes
# Goal: Compare loading composition with specialization.
# Key concepts:
# - Payload: Loadable composition arc.
# - Specializes: Supplies fallback opinions.
# - Composition arc: Connects authored scene descriptions.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 09 payload vs specializes example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "16_payload_vs_specializes/"
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


robot = stage.GetPrimAtPath(
    "/World/Robot"
)

body_prim = stage.GetPrimAtPath(
    "/World/Robot/Body"
)

if not body_prim.IsValid():
    raise RuntimeError(
        "/World/Robot/Body not found."
    )


body = UsdGeom.Cube(body_prim)


print()
print("========================================")
print("PAYLOAD vs SPECIALIZES")
print("========================================")

print()
print("Specializes opinion:")
print("size = 2")

print()
print("Payload opinion:")
print("size = 4")

print()
print("Final composed size:")
print(body.GetSizeAttr().Get())

print()
print("Expected:")
print("P > S")
print("Therefore size = 4")

print()
print("Payload loaded:")
print(robot.IsLoaded())

print()
print("========================================")
