#!/usr/bin/env bash
# Documentation: 02_02 - Time Samples
# Goal: Understand animation through time-sampled attributes.
# Key concepts demonstrated by the generated lesson:
# - timeSamples: Attribute values at specific time codes.
# - TimeCode: Selects the time used to evaluate an attribute.
# - Interpolation: Determines values between authored samples.
# This generator creates or updates the lesson files.

# Goal: Generate or maintain the OpenUSD lesson: 02 02 create time samples.
# Generated assets are stored in the project lesson directories.
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
LESSON="$PROJECT/02_transforms/02_time_samples"

mkdir -p "$LESSON"

# ============================================================
# 1. USDA
# ============================================================

cat > "$LESSON/time_samples.usda" <<'USDA'
#usda 1.0

# Goal:
# Animate a robot gripper finger using time samples.
# Understand time codes, interpolation, and animated attributes.

(
    # defaultPrim: Entry point of this USD asset.
    defaultPrim = "World"

    # upAxis: Z is the vertical axis.
    upAxis = "Z"

    # startTimeCode: First frame of the animation.
    startTimeCode = 1

    # endTimeCode: Last frame of the animation.
    endTimeCode = 60

    # timeCodesPerSecond: Number of USD time codes per second.
    timeCodesPerSecond = 30

    # framesPerSecond: Preferred playback frame rate.
    framesPerSecond = 30
)

# Xform: Transformable grouping prim.
def Xform "World"
{
    # Gripper: Parent of both fingers.
    def Xform "Gripper"
    {
        # LeftFinger: Stationary finger.
        def Cube "LeftFinger"
        {
            # double: 64-bit floating-point value.
            # size: Cube edge length.
            double size = 1

            # double3: Three floating-point coordinates.
            # xformOp:translate: Translation in X, Y and Z.
            double3 xformOp:translate = (1, 1, 0.5)

            # uniform: Not time-varying.
            # token[]: Array of string-like identifiers.
            # xformOpOrder: Ordered list of active transforms.
            uniform token[] xformOpOrder = ["xformOp:translate"]

            # color3f[]: Array of RGB colors.
            # primvars:displayColor: Standard display color.
            color3f[] primvars:displayColor = [(0.2, 0.5, 0.9)]
        }

        # RightFinger: Animated finger.
        def Cube "RightFinger"
        {
            # Cube edge length.
            double size = 1

            # xformOp:translate: Transform attribute.
            # .timeSamples: Values assigned at specific time codes.
            # 1, 30, 60: Animation frame numbers.
            # Values: Translation vectors (X, Y, Z).
            #
            # OpenUSD interpolates between these samples.
            double3 xformOp:translate.timeSamples = {
                1: (3, 1, 0.5),
                30: (2, 1, 0.5),
                60: (3, 1, 0.5)
            }

            # Activate the animated translation operation.
            uniform token[] xformOpOrder = ["xformOp:translate"]

            # Orange display color.
            color3f[] primvars:displayColor = [(0.9, 0.5, 0.2)]
        }
    }
}
USDA

# ============================================================
# 2. PYTHON
# ============================================================

cat > "$LESSON/02_time_samples.py" <<'PYTHON'
from pathlib import Path

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

print("\nExercise 28 completed.")
PYTHON

echo "Created:"
echo "  $LESSON/time_samples.usda"
echo "  $LESSON/02_time_samples.py"
