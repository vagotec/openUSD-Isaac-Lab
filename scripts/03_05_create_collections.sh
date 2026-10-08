#!/usr/bin/env bash
# Documentation: 03_05 - Collections
# Goal: Understand named collections of scene objects.
# Key concepts demonstrated by the generated lesson:
# - CollectionAPI: Defines a named collection on a prim.
# - includes: Relationship listing collection members.
# - expansionRule: Controls membership of descendants.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 03 05 create collections.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/03_hierarchy/05_collections"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA
# ============================================================

cat > "$LESSON/collections.usda" <<'USDA'
#usda 1.0

# Goal:
# Create a named collection of robot parts.
# Understand collection membership without changing hierarchy.

(
    # defaultPrim: Entry point of the USD asset.
    defaultPrim = "World"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"
)

# Xform: Transformable grouping prim.
def Xform "World"
{
    # Robot: Parent of the robot components.
    def Xform "Robot" (
        prepend apiSchemas = ["CollectionAPI:gripperParts"]
    )
    {
        # collection:gripperParts:expansionRule:
        # Attribute controlling how collection targets are expanded.
        #
        # uniform: The value does not vary over time.
        # token: String-like identifier.
        # explicitOnly: Only explicitly included prims are members.
        uniform token collection:gripperParts:expansionRule = "explicitOnly"

        # collection:gripperParts:includes:
        # Relationship listing the included prim paths.
        #
        # prepend: List-edit operation that adds targets
        # before weaker list opinions.
        # rel: Relationship between USD prims.
        # gripperParts: Name of this collection.
        prepend rel collection:gripperParts:includes = [
            </World/Robot/Gripper/LeftFinger>,
            </World/Robot/Gripper/RightFinger>
        ]

        # Base: Robot base, not included in the collection.
        def Cube "Base"
        {
            # double: 64-bit floating-point value.
            # size: Length of each cube edge.
            double size = 1

            # double3: Translation along X, Y and Z.
            double3 xformOp:translate = (2, 1, 0.5)

            # uniform token[]: Ordered array of transform names.
            uniform token[] xformOpOrder = ["xformOp:translate"]

            # color3f[]: Array of RGB colors.
            # primvars:displayColor: Standard display color.
            color3f[] primvars:displayColor = [(0.5, 0.5, 0.5)]
        }

        # Gripper: Parent of the two fingers.
        def Xform "Gripper"
        {
            # LeftFinger: First collection member.
            def Cube "LeftFinger"
            {
                double size = 1
                double3 xformOp:translate = (1, 3, 0.5)
                uniform token[] xformOpOrder = ["xformOp:translate"]
                color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
            }

            # RightFinger: Second collection member.
            def Cube "RightFinger"
            {
                double size = 1
                double3 xformOp:translate = (3, 3, 0.5)
                uniform token[] xformOpOrder = ["xformOp:translate"]
                color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
            }
        }
    }
}
USDA

# ============================================================
# 2. PYTHON
# ============================================================

cat > "$LESSON/05_collections.py" <<'PYTHON'
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
PYTHON

echo "Created:"
echo "  $LESSON/collections.usda"
echo "  $LESSON/05_collections.py"
