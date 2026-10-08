# OpenUSD & NVIDIA Isaac Sim – Learning Lab

A practical OpenUSD learning project using NVIDIA Isaac Sim, Python, USDA, and Bash.

**Platform:** Ubuntu 24.04 LTS
**Development environment:** Visual Studio Code
**OpenUSD version:** 26.08
**NVIDIA Isaac Sim version:** 6.0.1
**Primary language:** Python
**USD text format:** USDA
**Project directory:** `~/projects/openUSD-Isaac-Lab`

---

# 1. Project Overview

## 1.1 What is this project?

This repository is a structured learning environment for understanding and using **OpenUSD (Universal Scene Description)**.

OpenUSD is a framework for describing, composing, and managing complex 3D scenes.

It is widely used in:

- 3D graphics and animation
- Digital twins
- Robotics
- Simulation
- Autonomous systems
- NVIDIA Isaac Sim
- Industrial visualization

The purpose of this project is not simply to create 3D objects.

The main goal is to understand how OpenUSD represents objects, organizes scenes, manages reusable assets, combines information from different files, and supports complex robotic environments.

The project starts with simple examples and gradually introduces more advanced OpenUSD concepts.

The final chapters combine several concepts into an integrated robot example.

---

## 1.2 Main Learning Objectives

After completing this project, the learner should understand:

1. How OpenUSD represents a 3D scene.
2. How stages, prims, and properties work.
3. How prims are organized into hierarchies.
4. How transformations are represented.
5. How multiple USD layers are combined.
6. How OpenUSD composition works.
7. How references and payloads differ.
8. How variants are created and selected.
9. How schemas define object capabilities.
10. How collections organize scene objects.
11. How geometry can be instantiated efficiently.
12. How asset paths are resolved.
13. How animation is represented using time samples.
14. How these concepts can be combined in a robot model.

A particularly important objective is understanding the difference between:

**USD scene description** and **robot simulation behavior**.

OpenUSD describes the structure and properties of a scene.

A robotics simulator such as Isaac Sim adds simulation capabilities, including physics, sensors, articulation, and robot control.

These concepts are related, but they are not identical.

---

# 2. Development Environment

## 2.1 Operating System

The project is developed on:

**Ubuntu 24.04 LTS**

The project is designed for a Linux-based development workflow.

Windows-specific tools are not required.

## 2.2 Main Software Components

| Component | Purpose |
|---|---|
| Ubuntu 24.04 LTS | Development operating system |
| Visual Studio Code | Code editor |
| Python | OpenUSD scripting and inspection |
| USDA | Human-readable USD scene description |
| OpenUSD 26.08 | Scene description and composition |
| NVIDIA Isaac Sim 6.0.1 | USD scene visualization and simulation environment |
| Bash | Project setup and lesson generation |

## 2.3 Important Python Environment Information

The OpenUSD Python API is available inside the configured Isaac Sim Python environment.

A normal Ubuntu Python installation does not necessarily include the `pxr` module.

For example:

```python
from pxr import Usd
```

may fail when executed using the system Python interpreter.

This does not necessarily indicate a problem with OpenUSD.

It usually means that the current Python interpreter does not have access to the OpenUSD Python libraries.

For the examples in this project, Python scripts that use OpenUSD or Isaac Sim APIs should be executed using the configured Isaac Sim Python environment.

---

# 3. How OpenUSD Works

Before studying the individual chapters, it is important to understand the fundamental OpenUSD architecture.

## 3.1 Basic Architecture

A simplified OpenUSD scene consists of:

```text
OpenUSD
│
├── Stage
│   │
│   ├── Prim
│   │   ├── Attributes
│   │   ├── Relationships
│   │   └── Metadata
│   │
│   ├── Prim
│   │   ├── Attributes
│   │   └── Child Prims
│   │
│   └── Prim
│
├── Layers
│
├── Composition
│   ├── References
│   ├── Payloads
│   ├── Inherits
│   ├── Variants
│   └── Specializes
│
└── Asset Resolution
```

### Stage

A **Stage** is the composed OpenUSD scene.

It provides access to the prims and properties that make up the scene.

A stage can combine information from multiple USD files.

### Prim

A **Prim** is an object in the scene hierarchy.

Examples include:

- A robot
- A gripper
- A robot link
- A cube
- A camera
- A light
- A transformation node

A prim is identified by its path.

Example:

```text
/World/Robot/Gripper
```

### Property

A property stores information associated with a prim.

OpenUSD distinguishes between two main property types:

- Attributes
- Relationships

### Attribute

An attribute stores typed data.

Examples:

- Position
- Rotation
- Scale
- Visibility
- Color
- Animation values

### Relationship

A relationship connects a prim or property to other scene objects using target paths.

Relationships do not store ordinary numerical values.

### Metadata

Metadata describes additional information about a prim, property, or layer.

Examples include:

- `kind`
- `active`
- `instanceable`
- `apiSchemas`
- `defaultPrim`

### Layer

A layer stores authored USD scene information.

A stage can combine information from multiple layers.

### Composition

Composition is the mechanism OpenUSD uses to combine authored opinions into a final scene.

This is one of the most important concepts in OpenUSD.

---

# 4. USDA File Format

## 4.1 What is USDA?

USDA is the human-readable text representation of OpenUSD.

Common USD file extensions include:

| Extension | Description |
|---|---|
| `.usda` | Human-readable ASCII USD |
| `.usdc` | Binary USD representation |
| `.usd` | USD file that may contain ASCII or binary data |
| `.usdz` | Packaged USD asset |

This project primarily uses `.usda` because it makes the underlying scene structure easier to understand.

## 4.2 Simple USDA Example

```usda
#usda 1.0

(
    defaultPrim = "World"
)

def Xform "World"
{
    def Cube "Box"
    {
        double size = 2
    }
}
```

### Explanation

**1. `#usda 1.0`**

Identifies the file as a USDA document.

**2. `defaultPrim`**

Specifies the default entry prim for the asset.

**3. `def`**

Defines a prim.

**4. `Xform`**

A typed schema commonly used for transformation and hierarchy.

**5. `"World"`**

The name of the prim.

**6. `Cube`**

A typed schema representing cube geometry.

**7. `double size = 2`**

Defines a typed attribute.

The resulting hierarchy is:

```text
/World
└── Box
```

---

# 5. Project Structure

The project is organized into seven main learning areas.

```text
openUSD-Isaac-Lab/
│
├── .vscode/
│
├── 01_basics/
│   ├── 01_stage_prim.py
│   ├── 01_stage_prim.usda
│   ├── 02_prim_specifiers/
│   ├── 03_properties/
│   ├── 04_metadata/
│   ├── 05_typed_schemas/
│   ├── 06_api_schemas/
│   └── 07_primvars/
│
├── 02_transforms/
│   ├── 01_transforms.py
│   ├── 01_transforms.usda
│   └── 02_time_samples/
│
├── 03_hierarchy/
│   ├── 01_prim_hierarchy.py
│   ├── 01_prim_hierarchy.usda
│   ├── 02_parent_child.py
│   ├── 02_parent_child.usda
│   ├── 03_model_kind/
│   ├── 04_visibility_purpose/
│   └── 05_collections/
│
├── 04_layers/
│   ├── 01_layers.py
│   ├── 01_layers_vscode.py
│   └── 02_layer_strength/
│
├── 05_composition/
│   ├── 01_references/
│   ├── 02_payload/
│   ├── 03_inherits/
│   ├── 04_specializes/
│   ├── 05_prim_stack/
│   ├── 06_livrps/
│   ├── 07_variant_vs_reference/
│   ├── 08_reference_vs_payload/
│   ├── 09_payload_vs_specializes/
│   ├── 10_list_editing/
│   ├── 11_instancing/
│   ├── 12_point_instancer/
│   └── 13_asset_resolution/
│
├── 06_variants/
│   └── 01_body_variant/
│
├── 07_robot/
│   ├── 01_robot_hierarchy/
│   └── 02_integrated/
│
├── scripts/
│
└── README.md
```

**Note:** The structure above summarizes the main lesson files and directories. Individual chapters can contain additional USDA assets, Python examples, or supporting files.

---

# 6. Learning Area 01 – OpenUSD Basics

Directory:

```text
01_basics/
```

This learning area introduces the fundamental building blocks of OpenUSD.

It contains seven chapters.

---

## 6.1 Chapter 01 – Stage and Prim

**Directory:** `01_basics/`

### Goal

Understand how OpenUSD represents a scene using stages and prims.

### Main Concepts

- Stage
- Prim
- Prim path
- Root prim
- Default prim
- Typed prims

### Example

A simple scene contains a world prim and a cube.

```text
/World
└── Box
```

The example demonstrates how a prim can be defined in USDA and accessed using Python.

### Important Python APIs

```python
Usd.Stage.Open(...)
stage.GetPrimAtPath(...)
stage.GetDefaultPrim()
```

### What You Learn

A stage is not simply a single object.

It represents the composed scene.

Prims are the individual objects inside that scene.

---

## 6.2 Chapter 02 – Prim Specifiers

**Directory:** `01_basics/02_prim_specifiers/`

### Goal

Understand the differences between the three major prim specifiers.

### Main Concepts

- `def`
- `over`
- `class`

### Example

```usda
def Xform "Robot"
{
}

over "Robot"
{
    double speed = 1.5
}

class "RobotTemplate"
{
    double maxSpeed = 2.0
}
```

### Explanation

**`def`**

Defines a prim.

**`over`**

Authors additional opinions about a prim.

**`class`**

Defines reusable prim specifications, commonly used with inheritance.

### What You Learn

OpenUSD can describe an object in multiple places.

A prim can receive additional information without requiring the original definition to be rewritten.

This is an important foundation for composition.

---

## 6.3 Chapter 03 – Properties

**Directory:** `01_basics/03_properties/`

### Goal

Understand how prims store information.

### Main Concepts

- Attributes
- Relationships
- Property names
- Typed values

### Example

A robot prim can have:

```text
Robot
├── Attribute: speed
├── Attribute: enabled
└── Relationship: controller
```

### What You Learn

Attributes store values.

Relationships store connections to other scene objects.

This distinction becomes especially important when building robot hierarchies and reusable assets.

---

## 6.4 Chapter 04 – Metadata

**Directory:** `01_basics/04_metadata/`

### Goal

Understand the role of metadata in OpenUSD.

### Main Concepts

- Prim metadata
- Layer metadata
- `kind`
- `active`
- `defaultPrim`

### Example

```usda
def Xform "Robot" (
    kind = "component"
)
{
}
```

### What You Learn

Metadata describes how an object should be interpreted or managed.

It is different from ordinary scene properties such as position or color.

---

## 6.5 Chapter 05 – Typed Schemas

**Directory:** `01_basics/05_typed_schemas/`

### Goal

Understand how typed schemas define the primary type of a prim.

### Main Concepts

- Schema
- Typed schema
- `UsdGeom.Xform`
- `UsdGeom.Cube`

### Example

```usda
def Cube "Box"
{
    double size = 2
}
```

### What You Learn

A typed schema defines the main interface and expected properties of a prim.

A cube and an Xform are both prims, but they represent different kinds of scene objects.

---

## 6.6 Chapter 06 – API Schemas

**Directory:** `01_basics/06_api_schemas/`

### Goal

Understand how API schemas add capabilities to existing prims.

### Main Concepts

- API schema
- Applied API schema
- `apiSchemas`
- Schema application

### Example

A prim can have a primary typed schema and additional applied API schemas.

```text
Prim
├── Primary typed schema
└── Applied API schemas
```

### What You Learn

A prim is not limited to the capabilities of its primary type.

Additional interfaces can be applied without changing its main typed schema.

This is useful in robotics and simulation, where objects often require additional functionality.

---

## 6.7 Chapter 07 – Primvars

**Directory:** `01_basics/07_primvars/`

### Goal

Understand primitive variables used to describe geometry-related data.

### Main Concepts

- Primvars
- `primvars:displayColor`
- Interpolation
- Geometry data

### Example

A cube can receive a display color using a primvar.

```usda
def Cube "Box"
{
    color3f[] primvars:displayColor = [(0.0, 0.5, 1.0)]
}
```

### What You Learn

Primvars are a standardized mechanism for storing geometry-related information.

They are particularly useful for colors and other data associated with geometric elements.

---

# 7. Learning Area 02 – Transformations and Animation

Directory:

```text
02_transforms/
```

This learning area explains how objects are positioned and animated.

---

## 7.1 Chapter 01 – Transformations

**Directory:** `02_transforms/`

### Goal

Understand how OpenUSD represents transformations.

### Main Concepts

- Translation
- Rotation
- Scale
- `xformOp`
- `xformOpOrder`

### Example

```usda
def Xform "Robot"
{
    double3 xformOp:translate = (1, 0, 0)

    uniform token[] xformOpOrder = [
        "xformOp:translate"
    ]
}
```

### Explanation

**`xformOp:translate`**

Defines a translation operation.

**`xformOpOrder`**

Defines the order in which transformation operations are applied.

**`uniform`**

Specifies an attribute variability classification.

Uniform attributes are not intended to vary over time.

**`token[]`**

Represents an array of token values.

### What You Learn

A transformation is not simply a position.

OpenUSD represents transformations using ordered operations.

The operation order can affect the final result.

---

## 7.2 Chapter 02 – Time Samples and Animation

**Directory:** `02_transforms/02_time_samples/`

### Goal

Understand how OpenUSD represents values that change over time.

### Main Concepts

- Time samples
- Time codes
- Animation
- Attribute evaluation
- Interpolation

### Example

```usda
def Xform "MovingObject"
{
    double3 xformOp:translate.timeSamples = {
        1: (0, 0, 0),
        30: (2, 0, 0),
        60: (0, 0, 0)
    }

    uniform token[] xformOpOrder = [
        "xformOp:translate"
    ]
}
```

### Explanation

At frame 1, the object is at the starting position.

At frame 30, the object has moved.

At frame 60, the object returns to its starting position.

### What You Learn

Animation data can be stored directly in a USD scene.

OpenUSD does not require a separate animation programming language to describe time-dependent values.

The animation can be inspected using Python and visualized in Isaac Sim.

---

# 8. Learning Area 03 – Hierarchy and Scene Organization

Directory:

```text
03_hierarchy/
```

This learning area explains how complex scenes are organized.

---

## 8.1 Chapter 01 – Prim Hierarchy

**Directory:** `03_hierarchy/`

### Goal

Understand parent-child relationships.

### Example

```text
/World
└── Robot
    ├── Base
    ├── Arm
    └── Gripper
```

### What You Learn

OpenUSD prim paths represent hierarchical relationships.

A robot can be represented as a tree of components.

This becomes important when working with articulated robot structures.

---

## 8.2 Chapter 02 – Parent-Child Transformations

**Directory:** `03_hierarchy/`

### Goal

Understand how transformations propagate through a hierarchy.

### Example

```text
World
└── Robot
    └── Arm
        └── Gripper
```

If the robot root moves, its children generally move with it.

### Main Concepts

- Local transformation
- World transformation
- Parent transformation
- Transformation inheritance

### What You Learn

A child prim's final position can depend on transformations authored on its ancestors.

This principle is essential for understanding robot component placement.

---

## 8.3 Chapter 03 – Model and Kind

**Directory:** `03_hierarchy/03_model_kind/`

### Goal

Understand OpenUSD model classification.

### Main Concepts

- `kind`
- `group`
- `component`
- Model hierarchy

### Example

```text
Robot       kind = group
└── Gripper kind = component
```

### What You Learn

The `kind` metadata provides information about the role of a model.

A group model can contain other models.

A component model represents an independently meaningful asset.

The chapter demonstrates how model classification can be inspected using Python.

---

## 8.4 Chapter 04 – Visibility and Purpose

**Directory:** `03_hierarchy/04_visibility_purpose/`

### Goal

Understand how OpenUSD controls visibility and rendering intent.

### Main Concepts

- Visibility
- Inherited visibility
- Purpose
- Render geometry
- Proxy geometry
- Guide geometry

### Example

A robot may contain:

```text
Robot
├── VisualMesh
├── CollisionProxy
└── HelperGeometry
```

These objects can serve different purposes.

### What You Learn

Visibility determines whether geometry is visible.

Purpose identifies the intended use of geometry.

The two concepts are related but distinct.

---

## 8.5 Chapter 05 – Collections

**Directory:** `03_hierarchy/05_collections/`

### Goal

Understand how multiple scene objects can be grouped logically.

### Main Concepts

- `Usd.CollectionAPI`
- Collection membership
- Include relationships
- Expansion rules

### Example

A robot gripper contains two fingers.

```text
Robot
└── Gripper
    ├── LeftFinger
    └── RightFinger
```

A collection named `gripperParts` can include both fingers.

### What You Learn

Collections allow objects to be grouped without changing their physical hierarchy.

This is useful for selecting or processing related robot components.

The example demonstrates collection membership inspection using Python.

---

# 9. Learning Area 04 – Layers

Directory:

```text
04_layers/
```

Layers are one of the fundamental concepts behind OpenUSD composition.

---

## 9.1 Chapter 01 – Layers

**Directory:** `04_layers/`

### Goal

Understand how OpenUSD scene descriptions are stored in layers.

### Main Concepts

- Root layer
- Sublayer
- Layer stack
- Authored opinions

### Example

```text
main.usda
└── robot.usda
```

A main scene can include information from another layer.

### What You Learn

A stage can contain scene descriptions from multiple files.

Each layer contributes information to the final composed scene.

---

## 9.2 Chapter 02 – Layer Strength

**Directory:** `04_layers/02_layer_strength/`

### Goal

Understand how conflicting opinions from different layers are resolved.

### Example

A base layer defines:

```text
Robot color = blue
```

A stronger layer defines:

```text
Robot color = orange
```

The stronger authored opinion determines the composed value.

### What You Learn

OpenUSD composition uses strength rules.

The final value is not determined simply by which file was created last.

Understanding layer strength is essential for non-destructive editing.

---

# 10. Learning Area 05 – Composition

Directory:

```text
05_composition/
```

Composition is one of the most important and advanced parts of OpenUSD.

It allows large scenes to be assembled from reusable assets and authored opinions.

This learning area contains thirteen chapters.

---

## 10.1 Chapter 01 – References

**Directory:** `05_composition/01_references/`

### Goal

Understand how external USD assets are reused.

### Example

```text
main.usda
└── references robot.usda
```

A reference allows one USD scene to incorporate a prim defined in another USD asset.

### Main Concepts

- References
- External assets
- Referenced prims
- Composition arcs

### What You Learn

References enable reusable assets.

A robot component can be defined once and referenced by multiple scenes.

---

## 10.2 Chapter 02 – Payloads

**Directory:** `05_composition/02_payload/`

### Goal

Understand how large assets can be loaded selectively.

### Main Concepts

- Payload
- Load
- Unload
- Deferred content

### Example

A main scene contains a robot asset through a payload.

The payload can be loaded or unloaded.

### What You Learn

Payloads are especially useful for large scenes.

They allow expensive content to be excluded until it is needed.

Unlike an ordinary reference, a payload participates in USD load management.

---

## 10.3 Chapter 03 – Inherits

**Directory:** `05_composition/03_inherits/`

### Goal

Understand reusable shared opinions.

### Example

Several robot components can inherit common properties from a shared definition.

```text
RobotTemplate
├── Shared properties
└── Shared configuration
```

### What You Learn

Inheritance allows common authored opinions to be reused.

Changes to shared definitions can affect multiple inheriting prims.

---

## 10.4 Chapter 04 – Specializes

**Directory:** `05_composition/04_specializes/`

### Goal

Understand specialization and fallback opinions.

### Main Concepts

- Specializes
- Shared definitions
- Fallback opinions
- Composition strength

### What You Learn

Specializes provides a mechanism for deriving more specific objects from reusable definitions.

Its composition behavior and strength differ from inherits.

---

## 10.5 Chapter 05 – Prim Stack

**Directory:** `05_composition/05_prim_stack/`

### Goal

Understand where a composed prim's information comes from.

### Main Concepts

- Prim stack
- Prim specifications
- Layer contributions
- Composition result

### Important Python API

```python
prim.GetPrimStack()
```

### What You Learn

A composed prim may contain information contributed by multiple layers.

The prim stack helps inspect those contributions.

This is particularly useful when debugging complex USD scenes.

---

## 10.6 Chapter 06 – LIVRPS

**Directory:** `05_composition/06_livrps/`

### Goal

Understand the major categories of composition strength.

### LIVRPS

```text
L - Local
I - Inherits
V - Variants
R - References
P - Payloads
S - Specializes
```

This mnemonic describes the relative strength of major composition arc categories, from stronger to weaker.

It is a useful conceptual guide, but actual composition also depends on the specific composition structure and layer ordering.

### What You Learn

OpenUSD uses well-defined composition rules.

Understanding these rules makes it easier to predict which authored opinions will win.

---

## 10.7 Chapter 07 – Variants vs References

**Directory:** `05_composition/07_variant_vs_reference/`

### Goal

Understand the differences between selecting alternatives and reusing assets.

### Variants

Variants select between different authored alternatives.

### References

References incorporate content from another asset or prim.

### Example

A robot can use variants to select an appearance while using references to reuse its component geometry.

### What You Learn

Variants and references solve different problems.

They can also be combined.

---

## 10.8 Chapter 08 – References vs Payloads

**Directory:** `05_composition/08_reference_vs_payload/`

### Goal

Compare references and payloads directly.

| Feature | Reference | Payload |
|---|---|---|
| Reuses external content | Yes | Yes |
| Supports load/unload behavior | No, not independently | Yes |
| Useful for large optional assets | Possible | Particularly suitable |
| Composition mechanism | Reference arc | Payload arc |

### What You Learn

References are useful for ordinary asset reuse.

Payloads are especially useful when loading large assets needs to be controlled.

---

## 10.9 Chapter 09 – Payloads vs Specializes

**Directory:** `05_composition/09_payload_vs_specializes/`

### Goal

Understand why these two composition mechanisms serve different purposes.

### Payload

Controls the inclusion of loadable content.

### Specializes

Provides specialization and fallback opinions.

### What You Learn

Not all composition arcs are interchangeable.

Choosing the correct arc depends on the intended behavior.

---

## 10.10 Chapter 10 – List Editing

**Directory:** `05_composition/10_list_editing/`

### Goal

Understand how list-valued composition data is modified.

### Main Concepts

- Prepend
- Append
- Delete
- List operations
- Reference lists

### Example

A scene references a cube from `base.usda`.

A stronger opinion can modify the reference list using list-editing operations.

### What You Learn

OpenUSD can modify list-valued composition data without replacing the entire list.

This is an important feature of non-destructive scene composition.

---

## 10.11 Chapter 11 – Native Instancing

**Directory:** `05_composition/11_instancing/`

### Goal

Understand how OpenUSD efficiently represents repeated assets.

### Main Concepts

- `instanceable`
- Instance
- Prototype
- Shared scene representation

### Example

A scene contains multiple instances of the same cube asset.

```text
World
├── CubeInstance_01
├── CubeInstance_02
└── CubeInstance_03
```

### What You Learn

Native instancing allows multiple scene objects to share composed representations.

This can reduce memory usage in large scenes.

---

## 10.12 Chapter 12 – PointInstancer

**Directory:** `05_composition/12_point_instancer/`

### Goal

Understand how many repeated objects can be represented efficiently.

### Main Concepts

- `UsdGeom.PointInstancer`
- Prototypes
- Prototype indices
- Positions
- Orientations
- Scales

### Example

A PointInstancer can represent many repeated objects using shared prototypes and per-instance data.

### What You Learn

PointInstancer is especially useful for large numbers of repeated objects.

It differs from native USD instancing in both structure and intended usage.

---

## 10.13 Chapter 13 – Asset Resolution

**Directory:** `05_composition/13_asset_resolution/`

### Goal

Understand how OpenUSD locates referenced assets.

### Main Concepts

- Asset paths
- Relative paths
- Asset resolver
- Referenced layers

### Example

```text
robot.usda
└── assets/
    └── gripper.usda
```

The robot file references the gripper using a relative asset path.

### Important Python APIs

```python
Sdf.ComputeAssetPathRelativeToLayer(...)
Ar.GetResolver().Resolve(...)
```

### What You Learn

A referenced asset must be located correctly.

Asset resolution is especially important when projects are moved between machines or deployed to other environments.

---

# 11. Learning Area 06 – Variants

Directory:

```text
06_variants/
```

---

## 11.1 Chapter 01 – Variant Sets

**Directory:** `06_variants/01_body_variant/`

### Goal

Understand how alternative versions of an object are represented.

### Main Concepts

- Variant sets
- Variants
- Variant selection
- Authored alternatives

### Example

A robot can have multiple appearances.

```text
Robot
└── Appearance
    ├── Blue
    └── Orange
```

Only the selected alternative contributes its variant opinions to the composed scene.

### Important Python APIs

```python
prim.GetVariantSets()
prim.GetVariantSet(...)
variant_set.SetVariantSelection(...)
```

### What You Learn

Variants allow multiple configurations to be stored in a single reusable USD asset.

They are useful for:

- Robot appearances
- Product configurations
- Alternative geometry
- Simulation configurations

---

# 12. Learning Area 07 – Robot Integration

Directory:

```text
07_robot/
```

This learning area connects the previously introduced OpenUSD concepts.

---

## 12.1 Chapter 01 – Robot Hierarchy

**Directory:** `07_robot/01_robot_hierarchy/`

### Goal

Represent a robot using a structured prim hierarchy.

### Example

```text
World
└── Robot
    ├── Base
    ├── Arm
    └── Gripper
```

### Main Concepts

- Robot root
- Child prims
- Component hierarchy
- Transform hierarchy

### What You Learn

A robot can be represented as a hierarchy of scene objects.

However, a prim hierarchy alone does not create a physically articulated robot.

Additional physics and articulation definitions are required for realistic robot simulation.

---

## 12.2 Chapter 02 – Integrated Robot

**Directory:** `07_robot/02_integrated/`

### Goal

Combine multiple OpenUSD concepts into one practical robot scene.

This chapter is the integration exercise for the learning project.

### Main Concepts

- Prim hierarchy
- References
- Asset resolution
- Model and kind
- Variant sets
- Collections
- Time samples
- Animation

### Example Architecture

```text
World
└── Robot
    │
    ├── Model classification
    │   └── kind = group
    │
    ├── Gripper
    │   │
    │   ├── Referenced gripper asset
    │   │
    │   ├── Appearance variants
    │   │   ├── blue
    │   │   └── orange
    │   │
    │   ├── LeftFinger
    │   │
    │   └── RightFinger
    │       └── Time-sampled animation
    │
    └── Collection
        └── gripperParts
```

The diagram summarizes the logical features of the example. Collections and variant sets are USD properties and composition constructs, not necessarily separate child prims.

### 12.2.1 Model Classification

The example uses:

```text
Robot kind: group
Gripper kind: component
```

This demonstrates OpenUSD model hierarchy concepts.

### 12.2.2 Appearance Variants

The gripper supports two appearance variants:

```text
blue
orange
```

The example inspects the available variants and the selected appearance.

### 12.2.3 Collection Membership

The example contains a collection named:

```text
gripperParts
```

The collection includes the gripper fingers.

Python is used to verify collection membership.

### 12.2.4 Right Finger Animation

The right finger has time-sampled translation values.

The tested example reports:

```text
Frame 1:  (0.75, 0.0, 0.25)
Frame 30: (0.25, 0.0, 0.25)
Frame 60: (0.75, 0.0, 0.25)
```

The finger moves from its initial position toward the center and then returns.

This demonstrates time-sampled USD animation.

### 12.2.5 Example Runtime Output

```text
=== CHAPTER 30: INTEGRATED ROBOT ===

Robot kind: group
Gripper kind: component
Gripper is model: True

Appearance variants: ['blue', 'orange']
Selected appearance: blue

Right finger in collection: True

RIGHT FINGER ANIMATION

Frame 1: (0.75, 0.0, 0.25)
Frame 30: (0.25, 0.0, 0.25)
Frame 60: (0.75, 0.0, 0.25)

Animation started.
```

**Note:** The output still uses the original chapter label `CHAPTER 30` in this example. The reorganized project places it in `07_robot/02_integrated/`.

### What You Learn

The integrated robot example demonstrates how several OpenUSD concepts work together.

It is the transition from isolated learning examples toward a more realistic robot asset.

---

# 13. Shell Script Organization

All lesson-generation scripts are stored in:

```text
scripts/
```

## 13.1 Naming Convention

The naming convention is:

```text
<AREA>_<CHAPTER>_create_<TOPIC>.sh
```

Example:

```text
01_07_create_primvars.sh
```

Explanation:

```text
01       Learning area
07       Chapter number
create   Script purpose
primvars Topic
```

Another example:

```text
05_12_create_point_instancer.sh
```

This script belongs to:

```text
05_composition/
```

and creates the PointInstancer lesson.

## 13.2 Why Use Generator Scripts?

The scripts provide a reproducible way to create learning examples.

They can perform tasks such as:

- Creating directories
- Creating USDA files
- Creating Python examples
- Writing example scene descriptions
- Preparing lesson-specific assets

The goal is to make the learning process repeatable and understandable.

## 13.3 Important Rule

Some scripts may modify files that already exist.

Do not execute all generator scripts automatically without reviewing their contents.

In particular, the integrated robot completion script may perform additional changes beyond creating one isolated example.

The current project files have already been reorganized and tested.

---

# 14. Running the Examples

## 14.1 Open the Project

Ubuntu terminal:

```bash
cd ~/projects/openUSD-Isaac-Lab

code .
```

## 14.2 Open a USDA File

USDA files can be inspected directly in Visual Studio Code.

For example:

```text
01_basics/07_primvars/primvars.usda
```

A USDA file is a text representation of the scene description.

## 14.3 Open a Scene in Isaac Sim

Isaac Sim can open supported USD files for visualization.

The project also uses Python scripts to open USD stages programmatically.

A typical Isaac Sim Python example is:

```python
from pathlib import Path
import omni.usd

project = Path.home() / "projects/openUSD-Isaac-Lab"

usd_file = project / "01_basics/07_primvars/primvars.usda"

omni.usd.get_context().open_stage(str(usd_file))
```

This example opens the specified USD stage in Isaac Sim.

## 14.4 Run Python Through the Isaac Sim Executor

The configured development workflow uses the Isaac Sim VS Code integration.

The Python executor is available at:

```text
127.0.0.1:8226
```

General workflow:

1. Start Isaac Sim.
2. Ensure the Python execution service is available.
3. Open the project in VS Code.
4. Open the desired Python example.
5. Execute it through the Isaac Sim VS Code integration.
6. Inspect the output and the scene.

The executor address is a local development configuration and may differ on another machine.

---

# 15. Python APIs Used in This Project

The following table summarizes important OpenUSD APIs and concepts.

| API or Concept | Purpose |
|---|---|
| `Usd.Stage.Open()` | Opens an existing USD stage |
| `Usd.Stage.CreateNew()` | Creates a new stage |
| `GetPrimAtPath()` | Retrieves a prim using its path |
| `GetDefaultPrim()` | Retrieves the stage's default prim |
| `UsdGeom.Xform` | Represents transformable scene objects |
| `UsdGeom.Cube` | Represents cube geometry |
| `UsdGeom.Xformable` | Provides transformation-related operations |
| `GetPrimStack()` | Inspects contributing prim specifications |
| `Usd.CollectionAPI` | Defines and inspects collections |
| `UsdGeom.PointInstancer` | Represents repeated geometry efficiently |
| `GetVariantSets()` | Retrieves variant sets on a prim |
| `GetVariantSet()` | Retrieves a specific variant set |
| `SetVariantSelection()` | Selects a variant |
| `Sdf.Layer` | Represents authored USD layer data |
| `Sdf.Path` | Represents USD object paths |
| `Ar.GetResolver()` | Accesses the asset resolver |
| `omni.usd.get_context()` | Accesses the Isaac Sim USD context |

These APIs are introduced gradually throughout the lessons.

---

# 16. Important OpenUSD Syntax

The following USDA syntax appears frequently in the project.

## 16.1 `def`

Defines a prim.

```usda
def Xform "Robot"
{
}
```

## 16.2 `over`

Authors opinions about a prim.

```usda
over "Robot"
{
}
```

## 16.3 `class`

Defines reusable prim specifications.

```usda
class "RobotTemplate"
{
}
```

## 16.4 `uniform`

Specifies uniform variability.

```usda
uniform token purpose = "render"
```

Uniform attributes are not intended to vary over time.

## 16.5 `token`

A token is a string-like value commonly used for identifiers and enumerated values.

Example:

```usda
uniform token visibility = "inherited"
```

## 16.6 `[]`

Square brackets represent arrays in USDA type declarations and values.

Example:

```usda
token[] names = ["left", "right"]
```

## 16.7 `rel`

Defines a relationship.

Example:

```usda
rel controller = </World/Controller>
```

## 16.8 `prepend`

A list-editing operation that adds entries before weaker list contributions.

Example:

```usda
prepend references = @./robot.usda@
```

## 16.9 `@...@`

Represents an asset path in USDA.

Example:

```usda
@./assets/gripper.usda@
```

## 16.10 `<...>`

Represents a USD scene path in contexts such as relationships and reference prim paths.

Example:

```usda
</World/Robot>
```

## 16.11 `timeSamples`

Stores attribute values at specific times.

Example:

```usda
double3 xformOp:translate.timeSamples = {
    1: (0, 0, 0),
    30: (1, 0, 0)
}
```

---

# 17. Validation and Testing

The project includes Python examples and an integrated validation script.

## 17.1 Validation Script

Current location:

```text
07_robot/02_integrated/02_verify_previous.py
```

This script checks seven selected OpenUSD examples.

## 17.2 Tested Topics

The validation covers:

1. List Editing
2. Model and Kind
3. Native Instancing
4. PointInstancer
5. Collections
6. Asset Resolution
7. Integrated Robot

## 17.3 Latest Successful Validation

**Date:** 2026-10-08

The validation was executed through the Isaac Sim Python executor.

```text
=== OPENUSD FINAL VALIDATION ===

PASS: 23 - List Editing
PASS: 24 - Model and Kind
PASS: 26.1 - Instancing
PASS: 26.2 - PointInstancer
PASS: 27 - Collections
PASS: 29 - Asset Resolution
PASS: 30 - Integrated Robot

RESULT: 7 PASS, 0 FAIL
```

The labels shown in the test output correspond to the original chapter numbering before project reorganization.

## 17.4 Validation After Documentation

The project documentation was extended on 2026-10-08.

The following files received additional comments:

| File Type | Files Updated |
|---|---:|
| USDA | 49 |
| Python | 34 |
| Shell | 33 |
| **Total** | **116** |

Python and Bash syntax checks completed successfully.

The seven OpenUSD validation tests were executed again after the documentation changes.

**Result:**

```text
7 PASS
0 FAIL
```

## 17.5 Validation Scope

The seven passing tests confirm that the selected examples work in the tested environment.

They do not constitute a complete automated test of every chapter or every possible OpenUSD behavior.

Individual lessons can also be executed and inspected manually.

---

# 18. Project Development History

## Phase 1 – Basic OpenUSD Concepts

Initial lessons introduced:

- Stages
- Prims
- Hierarchies
- Transformations
- Layers

## Phase 2 – Composition

The project expanded to cover:

- References
- Payloads
- Variants
- Inherits
- Specializes
- Prim stacks
- LIVRPS

## Phase 3 – Advanced Scene Features

Additional lessons introduced:

- Prim specifiers
- Properties
- Metadata
- Schemas
- Primvars
- List editing
- Model and kind
- Visibility and purpose
- Instancing
- Collections
- Animation
- Asset resolution

## Phase 4 – Integrated Robot

The integrated robot example combined several previously studied concepts.

This included:

- Reusable gripper assets
- Model classification
- Appearance variants
- Collections
- Animated finger movement

## Phase 5 – Project Reorganization

**Date:** 2026-10-08

The project was reorganized into seven thematic learning areas.

The previous global chapter numbering was replaced with numbering local to each learning area.

For example:

```text
Old:
05_composition/26_instancing/02_point_instancer/

New:
05_composition/12_point_instancer/
```

The shell scripts were renamed to follow the new structure.

## Phase 6 – Documentation

**Date:** 2026-10-08

English learning objectives and concept explanations were added to 116 files.

The OpenUSD validation was executed again successfully.

---

# 19. Design Principles

This project follows several important principles.

## 19.1 Understand the Architecture First

The objective is to understand the underlying concepts before studying every API parameter.

For example, before using composition APIs, the learner should understand:

- What a layer is
- What an opinion is
- Why composition is necessary
- How composition strength works

## 19.2 Use Practical Examples

Concepts should be demonstrated using actual USDA and Python examples.

Whenever possible, an example should be visible in Isaac Sim.

## 19.3 Keep Examples Reproducible

Shell scripts are used to generate lesson files.

The project should be understandable and reproducible without relying entirely on manual editor operations.

## 19.4 Prefer Readable USDA

Human-readable USDA is preferred for learning.

It makes the scene structure and authored opinions visible.

## 19.5 Separate Scene Description from Simulation

OpenUSD describes scene data.

Isaac Sim provides the environment for visualization and simulation.

Robot physics, joints, and control systems require additional concepts beyond basic USD scene hierarchy.

## 19.6 Use English Code Documentation

Code comments and technical documentation inside project files are written in English.

This makes the examples easier to reuse in international development environments.

---

# 20. What Has Been Achieved?

The project now provides a structured introduction to important OpenUSD concepts.

The implemented learning material covers:

| Area | Chapters |
|---|---:|
| Basics | 7 |
| Transformations and Animation | 2 |
| Hierarchy | 5 |
| Layers | 2 |
| Composition | 13 |
| Variants | 1 |
| Robot Integration | 2 |
| **Total** | **32** |

The project has moved beyond simple USD object creation.

It now includes examples demonstrating composition, asset reuse, model organization, instancing, animation, and robot-related scene structures.

---

# 21. Limitations

This repository is an OpenUSD learning project.

It is not yet a complete robotics simulation framework.

The current integrated robot example demonstrates scene description and animation concepts.

It does not establish that the following features have been implemented:

- Physics-based robot articulation
- Joint controllers
- ROS 2 integration
- Robot inverse kinematics
- Collision-aware motion planning
- Robot sensor simulation
- Real robot hardware control
- Sim-to-real deployment

These features require additional development.

---

# 22. Next Project – OpenMANIPULATOR-X

The next planned step is to apply the OpenUSD concepts to a more realistic robot model.

The selected robot is:

**ROBOTIS OpenMANIPULATOR-X**

The intention is to move away from isolated examples and use a coherent robot model as the basis for further learning.

## 22.1 Why OpenMANIPULATOR-X?

The OpenMANIPULATOR-X provides a practical robotics example with:

- A robot base
- Multiple arm links
- Revolute joints
- A gripper
- Visual geometry
- A kinematic hierarchy

It is suitable for connecting OpenUSD scene concepts with robotics.

## 22.2 Planned Learning Topics

The next project may include:

### Robot Geometry

Understand how robot geometry is represented using meshes.

### Robot Hierarchy

Organize the robot into links and components.

### URDF

Study the robot's kinematic description.

### OpenUSD

Represent the robot's scene structure and visual geometry.

### Isaac Sim

Visualize and inspect the robot in a simulation environment.

### Joints and Articulation

Introduce physics and articulation concepts after the OpenUSD structure is understood.

### ROS 2

Later connect the robot model to ROS 2 Jazzy.

## 22.3 Planned Architecture

```text
OpenMANIPULATOR-X
│
├── Robot Description
│   ├── URDF
│   └── Mesh Assets
│
├── OpenUSD Representation
│   ├── Stage
│   ├── Robot Root
│   ├── Links
│   ├── Transforms
│   ├── References
│   └── Materials
│
├── NVIDIA Isaac Sim
│   ├── Visualization
│   └── Future Physics Integration
│
└── Future ROS 2 Integration
    ├── ROS 2 Jazzy
    ├── Robot State
    └── Robot Control
```

This is a planned architecture, not a claim that all components are already implemented.

---

# 23. URDF and OpenUSD

An important future learning objective is understanding the relationship between URDF and OpenUSD.

## 23.1 URDF

URDF stands for:

**Unified Robot Description Format**

It is commonly used in ROS-based robotics.

URDF describes:

- Robot links
- Joints
- Visual geometry
- Collision geometry
- Inertial properties

## 23.2 OpenUSD

OpenUSD provides a more general scene description framework.

It supports:

- Scene hierarchies
- Geometry
- Materials
- Composition
- Asset reuse
- Variants
- Animation
- Extensible schemas

## 23.3 Important Difference

URDF is primarily focused on robot description.

OpenUSD is a general-purpose scene description and composition framework.

A URDF robot can be imported into a compatible simulation environment and represented using USD prims.

However, converting URDF into USD requires appropriate mapping of robot concepts.

A USD transform hierarchy alone is not equivalent to a complete articulated robot model.

---

# 24. Recommended Learning Approach

The project should be studied in the following order:

```text
01_basics
    ↓
02_transforms
    ↓
03_hierarchy
    ↓
04_layers
    ↓
05_composition
    ↓
06_variants
    ↓
07_robot
    ↓
OpenMANIPULATOR-X
```

The learner should focus on understanding the relationships between concepts.

For example:

**Stage → Prim → Hierarchy → Transformations**

and:

**Layer → Opinion → Composition → Final Scene**

and:

**Reference → Asset Reuse → Robot Components**

and:

**Time Samples → Animation → Robot Movement**

Understanding these relationships is more valuable than memorizing individual API calls.

---

# 25. Useful Resources

## OpenUSD

Official OpenUSD website:

https://openusd.org/

OpenUSD documentation:

https://openusd.org/release/

OpenUSD API documentation:

https://openusd.org/release/api/index.html

## NVIDIA Isaac Sim

Official documentation:

https://docs.isaacsim.omniverse.nvidia.com/

## NVIDIA Isaac Lab

Official documentation:

https://isaac-sim.github.io/IsaacLab/

## ROS 2 Jazzy

Official documentation:

https://docs.ros.org/en/jazzy/

## ROBOTIS OpenMANIPULATOR-X

Official documentation:

https://emanual.robotis.com/docs/en/platform/openmanipulator_x/overview/

---

# 26. Project Status

**Last updated:** 2026-10-08

| Component | Status |
|---|---|
| OpenUSD basic lessons | Completed |
| Transform examples | Completed |
| Hierarchy examples | Completed |
| Layer examples | Completed |
| Composition examples | Completed |
| Variant examples | Completed |
| Integrated robot example | Completed |
| Project reorganization | Completed |
| Initial code documentation | Completed |
| Seven selected runtime validation tests | Passed |
| Detailed per-API comment review | Pending |
| OpenMANIPULATOR-X integration | Planned |
| Physics articulation | Planned |
| ROS 2 integration | Planned |

---

# 27. Final Summary

This project demonstrates how OpenUSD can be learned systematically through practical examples.

The learning process begins with simple scene descriptions and progresses toward more advanced concepts such as:

- Layer composition
- References
- Payloads
- Variants
- Instancing
- Asset resolution
- Collections
- Animation
- Robot scene organization

The integrated robot example combines multiple concepts in one scene and serves as the transition toward more realistic robotics applications.

The next major objective is to use the **OpenMANIPULATOR-X** as a practical robot model for studying the relationship between:

**URDF, OpenUSD, NVIDIA Isaac Sim, and eventually ROS 2.**

The long-term goal is to understand not only how a robot is represented visually, but also how its scene description, kinematic structure, simulation behavior, and software integration fit together.

---

**Project:** OpenUSD & NVIDIA Isaac Sim Learning Lab
**Platform:** Ubuntu 24.04 LTS
**OpenUSD:** 26.08
**Isaac Sim:** 6.0.1
**Documentation date:** 2026-10-08
