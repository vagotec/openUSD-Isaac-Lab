# Documentation: 02_02 - Time Samples
# Goal: Understand animation through time-sampled attributes.
# Key concepts:
# - timeSamples: Attribute values at specific time codes.
# - TimeCode: Selects the time used to evaluate an attribute.
# - Interpolation: Determines values between authored samples.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 02 time samples example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

from pathlib import Path

import omni.timeline
import omni.usd
from pxr import Usd, UsdGeom

# Use an absolute path for the Isaac Sim Python server.
USD_FILE = (
    Path.home()
    / "projects/openUSD-Isaac-Lab"
    / "02_transforms/02_time_samples/time_samples.usda"
)

if not USD_FILE.is_file():
    raise FileNotFoundError(USD_FILE)

# Open the USD scene in Isaac Sim.
context = omni.usd.get_context()

if not context.open_stage(str(USD_FILE)):
    raise RuntimeError(f"Could not open: {USD_FILE}")

stage = context.get_stage()

# Get the animated finger.
prim = stage.GetPrimAtPath("/World/Gripper/RightFinger")

if not prim.IsValid():
    raise RuntimeError("RightFinger prim not found")

# Xformable provides access to transformation operations.
xformable = UsdGeom.Xformable(prim)

# Find the translate operation.
translate_op = next(
    (
        op
        for op in xformable.GetOrderedXformOps()
        if op.GetOpType() == UsdGeom.XformOp.TypeTranslate
    ),
    None,
)

if translate_op is None:
    raise RuntimeError("Translate operation not found")

print("\n=== TIME SAMPLES ===")

print("Start:", stage.GetStartTimeCode())
print("End:", stage.GetEndTimeCode())
print("Time codes per second:", stage.GetTimeCodesPerSecond())

# Read authored time samples.
samples = translate_op.GetTimeSamples()

print("\nAUTHORED TIME SAMPLES")

for time in samples:
    position = translate_op.Get(Usd.TimeCode(time))
    print(f"Frame {time}: {tuple(position)}")

# Read an interpolated position.
middle_time = Usd.TimeCode(15)

position = translate_op.Get(middle_time)

print("\nINTERPOLATION")
print(f"Frame 15: {tuple(position)}")


# Start playback using the documented Omniverse Timeline API.
# The timeline operates in seconds, not USD frame numbers.
timeline = omni.timeline.get_timeline_interface()

# Convert the first USD frame into seconds.
start_seconds = (
    stage.GetStartTimeCode() / stage.GetTimeCodesPerSecond()
)

timeline.pause()
timeline.set_current_time(start_seconds)

# Loop between the stage's start and end time codes.
timeline.play(
    start_timecode=stage.GetStartTimeCode(),
    end_timecode=stage.GetEndTimeCode(),
    looping=True,
)

print("\nAnimation playback started.")
print("Use omni.timeline.get_timeline_interface().pause() to pause.")

print("\nExercise 28 completed.")
