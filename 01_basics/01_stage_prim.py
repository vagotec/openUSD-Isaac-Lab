# Documentation: 01_01 - Stage and Prim
# Goal: Understand how a USD stage contains prims.
# Key concepts:
# - Stage: The composed scene opened by OpenUSD.
# - Prim: A scene object identified by its USD path.
# - defaultPrim: The entry point of a USD asset.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 01 stage prim example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni
from pxr import UsdGeom, Gf


# ------------------------------------------------------------
# 1. STAGE
# Get the currently opened OpenUSD Stage from Isaac Sim.
# ------------------------------------------------------------

stage = omni.usd.get_context().get_stage()

if stage is None:
    raise RuntimeError("No Stage is currently open in Isaac Sim.")


# ------------------------------------------------------------
# 2. PRIM
# Create an Xform Prim at path /World.
# ------------------------------------------------------------

world = UsdGeom.Xform.Define(
    stage,
    "/World"
)


# ------------------------------------------------------------
# 3. DEFAULT PRIM
# Define /World as the default Prim of the Stage.
# ------------------------------------------------------------

stage.SetDefaultPrim(world.GetPrim())


# ------------------------------------------------------------
# 4. CUBE PRIM
# Create a Cube below /World.
#
# Hierarchy:
#
# /World
#     /MyCube
# ------------------------------------------------------------

cube = UsdGeom.Cube.Define(
    stage,
    "/World/MyCube"
)


# ------------------------------------------------------------
# 5. ATTRIBUTE
# Set the Cube's size attribute.
# ------------------------------------------------------------

cube.GetSizeAttr().Set(2.0)


# ------------------------------------------------------------
# 6. ATTRIBUTE
# Set the display color.
# ------------------------------------------------------------

cube.GetDisplayColorAttr().Set(
    [Gf.Vec3f(0.1, 0.4, 1.0)]
)


# ------------------------------------------------------------
# 7. INFORMATION
# Read information back from the Stage.
# ------------------------------------------------------------

cube_prim = cube.GetPrim()

print()
print("=== OpenUSD Basics ===")
print()

print("Stage:")
print(stage)

print()
print("Prim path:")
print(cube_prim.GetPath())

print()
print("Prim name:")
print(cube_prim.GetName())

print()
print("Prim type:")
print(cube_prim.GetTypeName())

print()
print("Cube size:")
print(cube.GetSizeAttr().Get())

print()
print("Scene created successfully.")
