# Documentation: 07_02 - Integrated Robot
# Goal: Combine multiple OpenUSD concepts in one robot scene.
# Key concepts:
# - Reference: Reuses the external gripper asset.
# - Collection: Groups the gripper fingers.
# - Time samples: Animate the right gripper finger.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 02 integrated example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

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
