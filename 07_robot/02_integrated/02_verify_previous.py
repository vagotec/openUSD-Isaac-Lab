# Documentation: 07_02 - Integrated Robot
# Goal: Combine multiple OpenUSD concepts in one robot scene.
# Key concepts:
# - Reference: Reuses the external gripper asset.
# - Collection: Groups the gripper fingers.
# - Time samples: Animate the right gripper finger.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 02 verify previous example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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

    assert prim.IsValid(), "Missing /World/Object"
    assert prim.GetTypeName() == "Cube", prim.GetTypeName()

    root_spec = stage.GetRootLayer().GetPrimAtPath("/World/Object")
    references = root_spec.referenceList.prependedItems

    assert len(references) == 1, references

    # Verify reference list editing in an isolated layer.
    layer = Sdf.Layer.CreateAnonymous("validation23.usda")
    spec = Sdf.CreatePrimInLayer(layer, "/Example")

    reference = Sdf.Reference("./example.usda", "/Example")
    spec.referenceList.prependedItems = [reference]

    assert len(spec.referenceList.prependedItems) == 1

    spec.referenceList.prependedItems = []

    assert len(spec.referenceList.prependedItems) == 0


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
    assert robot.IsValid(), "Missing /World/Robot"

    collection = Usd.CollectionAPI.Get(robot, "gripperParts")
    assert collection, "Collection not found"

    targets = set(collection.GetIncludesRel().GetTargets())

    expected = {
        Sdf.Path("/World/Robot/Gripper/LeftFinger"),
        Sdf.Path("/World/Robot/Gripper/RightFinger"),
    }

    assert targets == expected, (
        f"Expected {expected}, received {targets}"
    )


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
