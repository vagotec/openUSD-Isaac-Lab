# Documentation: 05_08 - References vs Payloads
# Goal: Compare immediate references with loadable payloads.
# Key concepts:
# - Reference: Includes reusable content in composition.
# - Payload: Allows selective loading of content.
# - Load rules: Control which payloads are included.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 08 reference vs payload example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "15_reference_vs_payload/"
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
print("REFERENCE vs PAYLOAD")
print("========================================")

print()
print("Payload opinion:")
print("size = 2")

print()
print("Reference opinion:")
print("size = 4")

print()
print("Final composed size:")
print(body.GetSizeAttr().Get())

print()
print("Expected:")
print("R > P")
print("Therefore size = 4")

print()
print("Payload loaded:")
robot = stage.GetPrimAtPath("/World/Robot")
print(robot.IsLoaded())

print()
print("========================================")
