# Documentation: 05_02 - Payloads
# Goal: Understand deferred loading of referenced content.
# Key concepts:
# - Payload: Composition arc that supports load and unload.
# - Load: Includes payload content in the composed stage.
# - Unload: Excludes payload content without deleting the asset.
# Run in the Isaac Sim Python executor if omni.usd is used.

# Goal: Explore the OpenUSD 02 payload example.
# Run this file in the Isaac Sim Python executor when it imports omni.usd.

import omni


USD_FILE = (
    "/home/sarvg/projects/"
    "openUSD-Isaac-Lab/"
    "05_composition/"
    "08_payload/"
    "main.usda"
)


# ------------------------------------------------------------
# Open Stage
# ------------------------------------------------------------

context = omni.usd.get_context()

success = context.open_stage(USD_FILE)

if not success:
    raise RuntimeError(
        f"Could not open Stage: {USD_FILE}"
    )

stage = context.get_stage()

if stage is None:
    raise RuntimeError("No Stage available.")


robot = stage.GetPrimAtPath("/World/Robot")

if not robot.IsValid():
    raise RuntimeError(
        "/World/Robot was not found."
    )


# ------------------------------------------------------------
# Initial state
# ------------------------------------------------------------

print()
print("========================================")
print("PAYLOAD")
print("========================================")

print()
print("Has payload:")
print(robot.HasPayload())

print()
print("Payload loaded:")
print(robot.IsLoaded())


# ------------------------------------------------------------
# Show loaded hierarchy
# ------------------------------------------------------------

print()
print("PRIMS WHILE LOADED:")

for prim in stage.Traverse():
    print(prim.GetPath())


# ------------------------------------------------------------
# UNLOAD
#
# The Prim /World/Robot remains,
# but the content coming from robot.usda is unloaded.
# ------------------------------------------------------------

print()
print("----------------------------------------")
print("UNLOAD PAYLOAD")
print("----------------------------------------")

robot.Unload()

print()
print("Payload loaded:")
print(robot.IsLoaded())

print()
print("PRIMS AFTER UNLOAD:")

for prim in stage.Traverse():
    print(prim.GetPath())


# ------------------------------------------------------------
# LOAD AGAIN
# ------------------------------------------------------------

print()
print("----------------------------------------")
print("LOAD PAYLOAD AGAIN")
print("----------------------------------------")

robot.Load()

print()
print("Payload loaded:")
print(robot.IsLoaded())

print()
print("PRIMS AFTER LOAD:")

for prim in stage.Traverse():
    print(prim.GetPath())


print()
print("========================================")
print("Lesson 08 completed.")
print("========================================")
