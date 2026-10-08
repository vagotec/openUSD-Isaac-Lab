# Documentation: 03_05 - Collections
# Goal: Understand named collections of scene objects.
# Key concepts:
# - CollectionAPI: Defines a named collection on a prim.
# - includes: Relationship listing collection members.
# - expansionRule: Controls membership of descendants.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 05 collections example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

from pathlib import Path

import omni.usd
from pxr import Sdf, Usd

PROJECT = Path.home() / "projects/openUSD-Isaac-Lab"
USD_FILE = PROJECT / "03_hierarchy/05_collections/collections.usda"

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Cannot open {USD_FILE}")

stage = context.get_stage()
robot = stage.GetPrimAtPath("/World/Robot")

if not robot.IsValid():
    raise RuntimeError("Missing /World/Robot")

collection = Usd.CollectionAPI.Get(robot, "gripperParts")

if not collection:
    raise RuntimeError("Collection gripperParts not found")

print("\n=== CHAPTER 27: COLLECTIONS ===")

includes = collection.GetIncludesRel().GetTargets()

print("Explicit targets:")
for target in includes:
    print(" ", target)

expected = {
    Sdf.Path("/World/Robot/Gripper/LeftFinger"),
    Sdf.Path("/World/Robot/Gripper/RightFinger"),
}

assert set(includes) == expected, (
    f"Expected {expected}, received {set(includes)}"
)

print("PASS: Chapter 27")
