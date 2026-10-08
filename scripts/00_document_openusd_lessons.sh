#!/usr/bin/env bash
set -euo pipefail

PROJECT="$HOME/projects/openUSD-Isaac-Lab"
cd "$PROJECT"

python3 - <<'PY'
from pathlib import Path
import ast
import datetime
import shutil
import subprocess

project = Path.home() / "projects/openUSD-Isaac-Lab"

# Documentation for every lesson.
# Key: subject directory and chapter number.
lessons = {
    "01_01": (
        "Stage and Prim",
        "Understand how a USD stage contains prims.",
        "Stage: The composed scene opened by OpenUSD.",
        "Prim: A scene object identified by its USD path.",
        "defaultPrim: The entry point of a USD asset.",
    ),
    "01_02": (
        "Prim Specifiers",
        "Understand def, over, and class prim specifications.",
        "def: Defines a prim.",
        "over: Contributes opinions to an existing prim.",
        "class: Defines reusable opinions for inheritance.",
    ),
    "01_03": (
        "Properties",
        "Distinguish attributes from relationships.",
        "Attribute: Stores typed data on a prim.",
        "Relationship: Stores target paths to other objects.",
        "Get: Reads a composed attribute value.",
    ),
    "01_04": (
        "Metadata",
        "Understand metadata attached to USD objects.",
        "Metadata: Describes a prim or layer.",
        "GetMetadata: Reads composed metadata.",
        "SetMetadata: Authors metadata in an editable layer.",
    ),
    "01_05": (
        "Typed Schemas",
        "Understand schema types such as Xform and Cube.",
        "Typed schema: Defines the primary type of a prim.",
        "Xform: Supports ordered transformation operations.",
        "Cube: Provides built-in cube geometry.",
    ),
    "01_06": (
        "API Schemas",
        "Understand additional capabilities applied to prims.",
        "API schema: Adds a defined interface to a prim.",
        "Apply: Authors an applied API schema.",
        "apiSchemas: Metadata recording applied API schemas.",
    ),
    "01_07": (
        "Primvars",
        "Understand geometry-related primitive variables.",
        "primvars: Namespace for geometry-related data.",
        "displayColor: Standard display-color primvar.",
        "Interpolation: Describes how primvar values map to geometry.",
    ),
    "02_01": (
        "Transforms",
        "Understand translation, rotation, scale, and operation order.",
        "xformOp: An individual transformation operation.",
        "xformOpOrder: Defines the order of transformations.",
        "Local transform: Transform relative to the parent prim.",
    ),
    "02_02": (
        "Time Samples",
        "Understand animation through time-sampled attributes.",
        "timeSamples: Attribute values at specific time codes.",
        "TimeCode: Selects the time used to evaluate an attribute.",
        "Interpolation: Determines values between authored samples.",
    ),
    "03_01": (
        "Prim Hierarchy",
        "Understand parent-child relationships between prims.",
        "Prim path: Identifies a prim within the scene hierarchy.",
        "Parent: The prim containing a child prim.",
        "Child: A prim nested beneath another prim.",
    ),
    "03_02": (
        "Parent-Child Transforms",
        "Understand how parent transformations affect children.",
        "Local transform: Transform relative to the parent.",
        "World transform: Result of accumulated parent transforms.",
        "Xformable: Schema interface for transformation operations.",
    ),
    "03_03": (
        "Model and Kind",
        "Understand model classification and valid model hierarchy.",
        "kind: Metadata describing a model's role.",
        "group: Model that contains other models.",
        "component: Independently meaningful model.",
    ),
    "03_04": (
        "Visibility and Purpose",
        "Understand visibility and intended rendering purpose.",
        "visibility: Controls whether an object is visible.",
        "purpose: Classifies render, proxy, or guide geometry.",
        "ComputeVisibility: Evaluates inherited visibility.",
    ),
    "03_05": (
        "Collections",
        "Understand named collections of scene objects.",
        "CollectionAPI: Defines a named collection on a prim.",
        "includes: Relationship listing collection members.",
        "expansionRule: Controls membership of descendants.",
    ),
    "04_01": (
        "Layers",
        "Understand how USD stores opinions in layers.",
        "Layer: Stores authored USD scene descriptions.",
        "Root layer: Main layer used to open a stage.",
        "SubLayer: Contributes opinions to a layer stack.",
    ),
    "04_02": (
        "Layer Strength",
        "Understand stronger and weaker layer opinions.",
        "Layer strength: Determines which authored opinion wins.",
        "Opinion: A value or metadata statement in a layer.",
        "Composition: Combines opinions into a scene.",
    ),
    "05_01": (
        "References",
        "Understand reusable assets through USD references.",
        "Reference: Composes prim data from another asset.",
        "Asset path: Locates an external USD layer.",
        "Prim path: Selects a prim inside the referenced asset.",
    ),
    "05_02": (
        "Payloads",
        "Understand deferred loading of referenced content.",
        "Payload: Composition arc that supports load and unload.",
        "Load: Includes payload content in the composed stage.",
        "Unload: Excludes payload content without deleting the asset.",
    ),
    "05_03": (
        "Inherits",
        "Understand reusable inherited opinions.",
        "inherits: Composition arc for shared opinions.",
        "Class prim: Common source of inherited properties.",
        "Composition strength: Determines overriding opinions.",
    ),
    "05_04": (
        "Specializes",
        "Understand specialization of reusable prim definitions.",
        "specializes: Composition arc for fallback opinions.",
        "Specialized prim: Prim that refines shared definitions.",
        "Opinion strength: Determines the composed result.",
    ),
    "05_05": (
        "Prim Stack",
        "Inspect all prim specifications contributing to a prim.",
        "Prim stack: Ordered specifications composing one prim.",
        "PrimSpec: Authored description of a prim in a layer.",
        "Composition: Combines the prim stack into a result.",
    ),
    "05_06": (
        "LIVRPS",
        "Understand USD composition strength ordering.",
        "LIVRPS: Local, Inherits, Variants, References, Payloads, Specializes.",
        "Local opinions: Strongest category in this ordering.",
        "Specializes: Weakest category in this ordering.",
    ),
    "05_07": (
        "Variants vs References",
        "Compare variant selection with external asset references.",
        "VariantSet: Defines alternative authored opinions.",
        "Variant selection: Chooses one alternative.",
        "Reference: Composes content from another prim or asset.",
    ),
    "05_08": (
        "References vs Payloads",
        "Compare immediate references with loadable payloads.",
        "Reference: Includes reusable content in composition.",
        "Payload: Allows selective loading of content.",
        "Load rules: Control which payloads are included.",
    ),
    "05_09": (
        "Payloads vs Specializes",
        "Compare loading composition with specialization.",
        "Payload: Loadable composition arc.",
        "Specializes: Supplies fallback opinions.",
        "Composition arc: Connects authored scene descriptions.",
    ),
    "05_10": (
        "List Editing",
        "Understand how USD list operations affect composition.",
        "prepend: Adds items before weaker list contributions.",
        "delete: Removes matching items from weaker lists.",
        "Reference list: Stores composition references on a prim.",
    ),
    "05_11": (
        "Native Instancing",
        "Understand memory-efficient native USD instances.",
        "instanceable: Enables instance sharing.",
        "Prototype: Shared composed scene representation.",
        "Instance: Prim using a shared prototype.",
    ),
    "05_12": (
        "PointInstancer",
        "Understand large groups of repeated geometry.",
        "PointInstancer: Efficiently represents repeated prototypes.",
        "protoIndices: Selects the prototype for each instance.",
        "positions: Stores positions of individual instances.",
    ),
    "05_13": (
        "Asset Resolution",
        "Understand how external USD asset paths are resolved.",
        "Asset resolver: Resolves an asset path to a resource.",
        "Relative path: Resolved against the containing layer.",
        "Reference: Connects an external asset to the scene.",
    ),
    "06_01": (
        "Variant Sets",
        "Understand selectable alternatives in USD assets.",
        "VariantSet: Collection of named alternatives.",
        "Variant: One selectable set of authored opinions.",
        "Selection: Determines the active alternative.",
    ),
    "07_01": (
        "Robot Hierarchy",
        "Represent a robot as a hierarchy of USD prims.",
        "Robot root: Parent prim organizing robot components.",
        "Transform hierarchy: Defines component placement.",
        "Child prim: Represents a nested robot component.",
    ),
    "07_02": (
        "Integrated Robot",
        "Combine multiple OpenUSD concepts in one robot scene.",
        "Reference: Reuses the external gripper asset.",
        "Collection: Groups the gripper fingers.",
        "Time samples: Animate the right gripper finger.",
    ),
}

# Some first lessons are stored directly in their subject directory.
def lesson_key(path):
    relative = path.relative_to(project)
    parts = relative.parts

    if not parts:
        return None

    subject = parts[0]

    if subject not in {
        "01_basics", "02_transforms", "03_hierarchy",
        "04_layers", "05_composition", "06_variants",
        "07_robot",
    }:
        return None

    subject_number = subject[:2]

    if len(parts) > 2:
        chapter_number = parts[1][:2]
    elif len(parts) == 2:
        chapter_number = "01"
    else:
        return None

    if not chapter_number.isdigit():
        return None

    return f"{subject_number}_{chapter_number}"


def lesson_for_generator(path):
    prefix = path.name[:5]

    if prefix in lessons:
        return prefix

    return None


stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
backup = project.parent / f"openusd_documentation_backup_{stamp}"

changes = []
counts = {"usda": 0, "py": 0, "sh": 0}

files = []

for subject in (
    "01_basics", "02_transforms", "03_hierarchy",
    "04_layers", "05_composition", "06_variants",
    "07_robot",
):
    files.extend((project / subject).rglob("*.usda"))
    files.extend((project / subject).rglob("*.py"))

files.extend((project / "scripts").glob("*.sh"))

for path in sorted(set(files)):
    if path.name == "00_document_openusd_lessons.sh":
        continue

    if path.suffix == ".sh":
        key = lesson_for_generator(path)
    else:
        key = lesson_key(path)

    if key not in lessons:
        continue

    title, goal, *concepts = lessons[key]
    original = path.read_text()
    marker = f"Documentation: {key} - {title}"

    # Idempotent: running again must not duplicate comments.
    if marker in original:
        continue

    if path.suffix == ".usda":
        header = (
            f"\n# {marker}\n"
            f"# Goal: {goal}\n"
            "# Key concepts:\n"
            + "".join(f"# - {item}\n" for item in concepts)
            + "\n"
        )

        if not original.startswith("#usda 1.0"):
            print(f"SKIP: unexpected USDA header: {path}")
            continue

        updated = original.replace(
            "#usda 1.0",
            "#usda 1.0" + header,
            1,
        )

    elif path.suffix == ".py":
        header = (
            f"# {marker}\n"
            f"# Goal: {goal}\n"
            "# Key concepts:\n"
            + "".join(f"# - {item}\n" for item in concepts)
            + "# Run in the Isaac Sim Python executor if omni.usd is used.\n\n"
        )

        updated = header + original

    else:
        header = (
            f"# {marker}\n"
            f"# Goal: {goal}\n"
            "# Key concepts demonstrated by the generated lesson:\n"
            + "".join(f"# - {item}\n" for item in concepts)
            + "# This generator creates or updates the lesson files.\n\n"
        )

        if not original.startswith("#!/usr/bin/env bash"):
            print(f"SKIP: unexpected shell header: {path}")
            continue

        updated = original.replace(
            "#!/usr/bin/env bash\n",
            "#!/usr/bin/env bash\n" + header,
            1,
        )

    # Validate Python syntax before saving.
    if path.suffix == ".py":
        ast.parse(updated, filename=str(path))

    changes.append((path, updated))
    counts[path.suffix.lstrip(".")] += 1

# Validate shell scripts before changing the project.
for path, content in changes:
    if path.suffix != ".sh":
        continue

    result = subprocess.run(
        ["bash", "-n"],
        input=content,
        text=True,
        capture_output=True,
    )

    if result.returncode != 0:
        raise RuntimeError(
            f"Shell syntax error in {path}: {result.stderr}"
        )

# Save original versions before applying documentation.
for path, _ in changes:
    relative = path.relative_to(project)
    destination = backup / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, destination)

for path, content in changes:
    path.write_text(content)

print("\n=== OPENUSD DOCUMENTATION ===")
print("USDA files updated:", counts["usda"])
print("Python files updated:", counts["py"])
print("Shell scripts updated:", counts["sh"])
print("Total files updated:", len(changes))
print("Backup:", backup)
print("Python and shell syntax: PASS")
print("\nOnly comments were added.")
print("OpenUSD runtime behavior has not been retested.")
PY
