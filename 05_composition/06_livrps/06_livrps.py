# Documentation: 05_06 - LIVRPS
# Goal: Understand USD composition strength ordering.
# Key concepts:
# - LIVRPS: Local, Inherits, Variants, References, Payloads, Specializes.
# - Local opinions: Strongest category in this ordering.
# - Specializes: Weakest category in this ordering.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 06 livrps example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "13_livrps/"
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
print("LIVRPS")
print("========================================")

print()
print("Inherited opinion:")
print("size = 2")
print("color = blue")

print()
print("Local opinion:")
print("size = 4")
print("color = red")

print()
print("FINAL COMPOSED RESULT:")

print()
print("size:")
print(body.GetSizeAttr().Get())

print()
print("color:")
print(body.GetDisplayColorAttr().Get())


print()
print("========================================")
print("PRIM STACK")
print("========================================")

for prim_spec in body_prim.GetPrimStack():

    print()
    print("Layer:")
    print(prim_spec.layer.identifier)

    print("Path:")
    print(prim_spec.path)

    print("Specifier:")
    print(prim_spec.specifier)


print()
print("========================================")
