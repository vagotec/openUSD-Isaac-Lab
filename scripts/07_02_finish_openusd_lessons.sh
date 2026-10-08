#!/usr/bin/env bash
# Documentation: 07_02 - Integrated Robot
# Goal: Combine multiple OpenUSD concepts in one robot scene.
# Key concepts demonstrated by the generated lesson:
# - Reference: Reuses the external gripper asset.
# - Collection: Groups the gripper fingers.
# - Time samples: Animate the right gripper finger.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 07 02 finish openusd lessons.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
cd "$PROJECT"

echo "=== OpenUSD finalization: chapters 23-30 ==="

# ============================================================
# 1. FIX CHAPTER 23
# ============================================================

python3 - <<'PY'
from pathlib import Path

generator = Path("scripts/05_10_create_list_editing.sh")
source = generator.read_text()

old = '''# Demonstrate list editing through a stronger session layer.
# The original USDA files remain unchanged.
print("\\n3. DELETE REFERENCE")

session = stage.GetSessionLayer()
stage.SetEditTarget(session)

session_spec = Sdf.CreatePrimInLayer(session, "/World/Object")

# Remove the reference contributed by the weaker root layer.
session_spec.referenceList.deletedItems = [
    Sdf.Reference("./base.usda", "/World/Box")
]

print("Deleted references:", session_spec.referenceList.deletedItems)

# Return to the root layer as the edit target.
stage.SetEditTarget(stage.GetRootLayer())

print("\\n4. RESULT")
print("Type after deletion:", prim.GetTypeName())'''

new = '''# Keep the visible Isaac Sim stage unchanged.
# Use a separate USD stage to demonstrate list editing.
print("\\n3. DELETE REFERENCE IN A SEPARATE STAGE")

test_stage = Usd.Stage.Open(str(USD_FILE))

if test_stage is None:
    raise RuntimeError("Could not open test stage")

test_prim = test_stage.GetPrimAtPath("/World/Object")

print("Type before deletion:", test_prim.GetTypeName())

# A stronger session layer can remove a weaker reference.
session = test_stage.GetSessionLayer()
session_spec = Sdf.CreatePrimInLayer(session, "/World/Object")

session_spec.referenceList.deletedItems = [
    Sdf.Reference("./base.usda", "/World/Box")
]

print("Deleted references:", session_spec.referenceList.deletedItems)

print("\\n4. RESULT")
print("Type after deletion:", test_prim.GetTypeName())
print("Isaac Sim viewport stage remains unchanged.")'''

if old in source:
    source = source.replace(old, new, 1)
elif new not in source:
    raise RuntimeError("Chapter 23 generator differs from expected content")

generator.write_text(source)
print("PASS: Chapter 23 generator updated")
PY

# Regenerate chapter 23 using its corrected generator.
bash scripts/05_10_create_list_editing.sh

# ============================================================
# 2. FIX CHAPTER 24
# ============================================================

python3 - <<'PY'
from pathlib import Path

generator = Path("scripts/03_03_create_model_kind.sh")
source = generator.read_text()

old = '''def Xform "World"
{
    # Gripper is a model containing two fingers.'''

new = '''# kind: Model classification metadata.
# group: A model that contains other models.
def Xform "World" (
    kind = "group"
)
{
    # Gripper is a model containing two fingers.'''

if old in source:
    source = source.replace(old, new, 1)
elif new not in source:
    raise RuntimeError("Chapter 24 generator differs from expected content")

generator.write_text(source)
print("PASS: Chapter 24 generator updated")
PY

bash scripts/03_03_create_model_kind.sh

# ============================================================
# 3. CREATE CHAPTER 30
# ============================================================

LESSON="$PROJECT/07_robot/02_integrated"
mkdir -p "$LESSON/assets"

# ------------------------------------------------------------
# 3.1 External gripper asset
# ------------------------------------------------------------

cat > "$LESSON/assets/gripper.usda" <<'USDA'
#usda 1.0

# Goal:
# Define a reusable animated gripper asset.
# Demonstrate hierarchy, model kind, transforms, and time samples.

(
    # defaultPrim: Default asset entry point.
    defaultPrim = "Gripper"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"

    # startTimeCode / endTimeCode: Animation frame range.
    startTimeCode = 1
    endTimeCode = 60

    # timeCodesPerSecond: USD time-code scale.
    timeCodesPerSecond = 30

    # framesPerSecond: Preferred playback frame rate.
    framesPerSecond = 30
)

# Xform: Transformable parent.
# kind: Model classification metadata.
# component: An independent model.
def Xform "Gripper" (
    kind = "component"
)
{
    # Cube: Left gripper finger.
    def Cube "LeftFinger" (
        # subcomponent: Part of a component model.
        kind = "subcomponent"
    )
    {
        # double: 64-bit floating-point value.
        # size: Cube edge length.
        double size = 0.5

        # double3: Three 64-bit coordinates.
        # xformOp:translate: Position of the cube center.
        double3 xformOp:translate = (-0.75, 0, 0.25)

        # uniform: Non-time-varying attribute.
        # token[]: Array of string-like identifiers.
        # xformOpOrder: Ordered list of active transforms.
        uniform token[] xformOpOrder = ["xformOp:translate"]

        # color3f[]: Array of RGB colors.
        # primvars:displayColor: Standard display color.
        color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
    }

    # Cube: Animated right gripper finger.
    def Cube "RightFinger" (
        kind = "subcomponent"
    )
    {
        double size = 0.5

        # .timeSamples: Values at specific USD time codes.
        # 1: Open; 30: Closed; 60: Open again.
        # Intermediate values are interpolated.
        double3 xformOp:translate.timeSamples = {
            1: (0.75, 0, 0.25),
            30: (0.25, 0, 0.25),
            60: (0.75, 0, 0.25)
        }

        uniform token[] xformOpOrder = ["xformOp:translate"]

        color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
    }
}
USDA

# ------------------------------------------------------------
# 3.2 Main robot scene
# ------------------------------------------------------------

cat > "$LESSON/robot.usda" <<'USDA'
#usda 1.0

# Goal:
# Combine references, model kind, hierarchy, variants,
# collections, display colors, and animation in one scene.

(
    # defaultPrim: Main entry point of the scene.
    defaultPrim = "World"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"

    # Animation range and time-code scale.
    startTimeCode = 1
    endTimeCode = 60
    timeCodesPerSecond = 30
    framesPerSecond = 30
)

# World: Root model grouping the robot.
# kind = group: Parent model containing component models.
def Xform "World" (
    kind = "group"
)
{
    # Robot: Another model group.
    # variantSets: Names of available variant sets.
    # variants: Default selection for a variant set.
    def Xform "Robot" (
        kind = "group"
        prepend variantSets = "appearance"
        variants = {
            string appearance = "blue"
        }
    )
    {
        # uniform token: Non-animated string-like attribute.
        # expansionRule = explicitOnly: Only named prims are members.
        uniform token collection:gripperParts:expansionRule = "explicitOnly"

        # rel: Relationship pointing to other prims.
        # collection:gripperParts:includes: Collection members.
        # prepend: List-edit operation adding relationship targets.
        prepend rel collection:gripperParts:includes = [
            </World/Robot/Gripper/LeftFinger>,
            </World/Robot/Gripper/RightFinger>
        ]

        # Base: Visible robot base.
        def Cube "Base" (
            kind = "component"
        )
        {
            double size = 1
            double3 xformOp:translate = (2, 2, 0.5)
            uniform token[] xformOpOrder = ["xformOp:translate"]
        }

        # Gripper: References geometry from an external asset.
        # @...@: Asset path.
        # ./assets/gripper.usda: Path relative to this layer.
        # </Gripper>: Prim selected inside the external asset.
        def Xform "Gripper" (
            prepend references = @./assets/gripper.usda@</Gripper>
        )
        {
            # Place the entire referenced gripper above the base.
            double3 xformOp:translate = (2, 2, 1.5)
            uniform token[] xformOpOrder = ["xformOp:translate"]
        }

        # variantSet: Named alternatives for scene opinions.
        # appearance: Name of this variant set.
        variantSet "appearance" = {
            # blue: First alternative.
            "blue" {
                over "Base" {
                    # Blue display color for the base.
                    color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
                }
            }

            # orange: Second alternative.
            "orange" {
                over "Base" {
                    # Orange display color for the base.
                    color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
                }
            }
        }
    }
}
USDA

# ------------------------------------------------------------
# 3.3 Isaac Sim scene and animation
# ------------------------------------------------------------

cat > "$LESSON/02_integrated.py" <<'PYTHON'
from pathlib import Path

import omni.timeline
import omni.usd
from pxr import Usd, UsdGeom

USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "07_robot/02_integrated/robot.usda"
)

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

print("\n=== CHAPTER 30: INTEGRATED ROBOT ===")

robot = stage.GetPrimAtPath("/World/Robot")
gripper = stage.GetPrimAtPath("/World/Robot/Gripper")
right = stage.GetPrimAtPath("/World/Robot/Gripper/RightFinger")

for prim in (robot, gripper, right):
    if not prim.IsValid():
        raise RuntimeError(f"Missing prim: {prim.GetPath()}")

print("Robot kind:", Usd.ModelAPI(robot).GetKind())
print("Gripper kind:", Usd.ModelAPI(gripper).GetKind())
print("Gripper is model:", gripper.IsModel())

variants = robot.GetVariantSets().GetVariantSet("appearance")
print("Appearance variants:", variants.GetVariantNames())
print("Selected appearance:", variants.GetVariantSelection())

collection = Usd.CollectionAPI.Get(robot, "gripperParts")
query = collection.ComputeMembershipQuery()

print(
    "Right finger in collection:",
    query.IsPathIncluded(right.GetPath()),
)

translate = right.GetAttribute("xformOp:translate")

print("\nRIGHT FINGER ANIMATION")

for frame in (1, 30, 60):
    value = translate.Get(Usd.TimeCode(frame))
    print(f"Frame {frame}: {tuple(value)}")

# Isaac Sim-specific playback.
# OpenUSD stores animation data; omni.timeline plays it.
timeline = omni.timeline.get_timeline_interface()

timeline.pause()
timeline.set_current_time(
    stage.GetStartTimeCode() / stage.GetTimeCodesPerSecond()
)

timeline.play(
    start_timecode=stage.GetStartTimeCode(),
    end_timecode=stage.GetEndTimeCode(),
    looping=True,
)

print("\nAnimation started.")
PYTHON

# ============================================================
# 4. CREATE SHARED VALIDATION SCRIPT
# ============================================================

cat > "$LESSON/02_verify_previous.py" <<'PYTHON'
from pathlib import Path

from pxr import Ar, Sdf, Usd, UsdGeom

PROJECT = Path.home() / "projects/openUSD-Isaac-Lab"

passed = 0
failed = 0


def check(name, function):
    global passed, failed

    try:
        function()
        print(f"PASS: {name}")
        passed += 1
    except Exception as error:
        print(f"FAIL: {name}: {error}")
        failed += 1


def open_stage(relative_path):
    path = PROJECT / relative_path

    if not path.is_file():
        raise FileNotFoundError(path)

    stage = Usd.Stage.Open(str(path))

    if stage is None:
        raise RuntimeError(f"Could not open: {path}")

    return stage


def verify_23():
    stage = open_stage("05_composition/10_list_editing/main.usda")
    prim = stage.GetPrimAtPath("/World/Object")

    assert prim.IsValid()
    assert prim.GetTypeName() == "Cube", prim.GetTypeName()

    # Demonstrate deletion only on this independent stage.
    spec = Sdf.CreatePrimInLayer(
        stage.GetSessionLayer(), "/World/Object"
    )

    spec.referenceList.deletedItems = [
        Sdf.Reference("./base.usda", "/World/Box")
    ]

    assert prim.GetTypeName() != "Cube"


def verify_24():
    stage = open_stage("03_hierarchy/03_model_kind/model_kind.usda")

    world = stage.GetPrimAtPath("/World")
    gripper = stage.GetPrimAtPath("/World/Gripper")

    assert world.IsGroup()
    assert gripper.IsModel()
    assert Usd.ModelAPI(gripper).GetKind() == "component"


def verify_26_1():
    stage = open_stage(
        "05_composition/11_instancing/main.usda"
    )

    for name in ("Cube_A", "Cube_B", "Cube_C"):
        prim = stage.GetPrimAtPath(f"/World/{name}")
        assert prim.IsInstance(), name

    assert len(stage.GetPrototypes()) == 1


def verify_26_2():
    stage = open_stage(
        "05_composition/12_point_instancer/"
        "point_instancer.usda"
    )

    prim = stage.GetPrimAtPath("/World/Boxes")
    instancer = UsdGeom.PointInstancer(prim)

    assert instancer

    positions = instancer.GetPositionsAttr().Get()
    indices = instancer.GetProtoIndicesAttr().Get()
    targets = instancer.GetPrototypesRel().GetTargets()

    assert len(positions) == 10
    assert len(indices) == 10
    assert len(targets) == 1


def verify_27():
    stage = open_stage("03_hierarchy/05_collections/collections.usda")

    robot = stage.GetPrimAtPath("/World/Robot")
    collection = Usd.CollectionAPI.Get(robot, "gripperParts")

    assert collection

    query = collection.ComputeMembershipQuery()

    assert query.IsPathIncluded(
        "/World/Robot/Gripper/LeftFinger"
    )
    assert query.IsPathIncluded(
        "/World/Robot/Gripper/RightFinger"
    )
    assert not query.IsPathIncluded("/World/Robot/Base")


def verify_29():
    stage = open_stage(
        "05_composition/13_asset_resolution/robot.usda"
    )

    layer = stage.GetRootLayer()
    spec = layer.GetPrimAtPath("/World/Robot/Gripper")

    assert spec is not None

    references = spec.referenceList.prependedItems
    assert len(references) == 1

    anchored = Sdf.ComputeAssetPathRelativeToLayer(
        layer, references[0].assetPath
    )

    resolved = Ar.GetResolver().Resolve(anchored)
    assert resolved, f"Unresolved asset: {anchored}"

    for name in ("LeftFinger", "RightFinger"):
        prim = stage.GetPrimAtPath(
            f"/World/Robot/Gripper/{name}"
        )
        assert prim.IsValid()
        assert prim.GetTypeName() == "Cube"


def verify_30():
    stage = open_stage("07_robot/02_integrated/robot.usda")

    world = stage.GetPrimAtPath("/World")
    robot = stage.GetPrimAtPath("/World/Robot")
    gripper = stage.GetPrimAtPath("/World/Robot/Gripper")

    assert world.IsGroup()
    assert robot.IsGroup()
    assert gripper.IsModel()

    variants = robot.GetVariantSets().GetVariantSet("appearance")
    assert set(variants.GetVariantNames()) == {"blue", "orange"}

    collection = Usd.CollectionAPI.Get(robot, "gripperParts")
    query = collection.ComputeMembershipQuery()

    assert query.IsPathIncluded(
        "/World/Robot/Gripper/RightFinger"
    )

    right = stage.GetPrimAtPath(
        "/World/Robot/Gripper/RightFinger"
    )

    translate = right.GetAttribute("xformOp:translate")
    assert translate.IsValid()
    assert len(translate.GetTimeSamples()) == 3

    for frame in (1, 30, 60):
        assert translate.Get(Usd.TimeCode(frame)) is not None


print("\n=== OPENUSD FINAL VALIDATION ===")

check("23 - List Editing", verify_23)
check("24 - Model and Kind", verify_24)
check("26.1 - Instancing", verify_26_1)
check("26.2 - PointInstancer", verify_26_2)
check("27 - Collections", verify_27)
check("29 - Asset Resolution", verify_29)
check("30 - Integrated Robot", verify_30)

print(f"\nRESULT: {passed} PASS, {failed} FAIL")

if failed:
    raise RuntimeError(f"{failed} OpenUSD validation checks failed")
PYTHON

# ============================================================
# 5. CHECK SHELL AND PYTHON SYNTAX
# ============================================================

echo
echo "=== Syntax checks ==="

bash -n scripts/05_10_create_list_editing.sh
bash -n scripts/03_03_create_model_kind.sh
bash -n scripts/07_02_finish_openusd_lessons.sh

python3 - <<'PY'
import ast
from pathlib import Path

paths = [
    Path("05_composition/10_list_editing/10_list_editing.py"),
    Path("03_hierarchy/03_model_kind/03_model_kind.py"),
    Path("07_robot/02_integrated/02_integrated.py"),
    Path("07_robot/02_integrated/02_verify_previous.py"),
]

for path in paths:
    ast.parse(path.read_text(), filename=str(path))
    print(f"PASS: Python syntax: {path}")
PY

echo
echo "=== FINAL FILES ==="
echo "$LESSON/assets/gripper.usda"
echo "$LESSON/robot.usda"
echo "$LESSON/02_integrated.py"
echo "$LESSON/02_verify_previous.py"

echo
echo "Shell and Python syntax checks completed."
echo "OpenUSD runtime validation must be run in Isaac Sim."
