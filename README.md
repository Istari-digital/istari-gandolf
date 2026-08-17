# Gandalf on the Eagle: Will It Fly?

This sample project models a small plastic figure of Gandalf riding a hand-launched foam eagle glider, and then checks — using computational fluid dynamics (CFD) — whether the combined design will actually fly. It is intended as a realistic, end-to-end example of an engineering workflow you can run through the [Istari Digital Platform](https://istaridigital.com): requirements, CAD geometry, design revisions, and simulation, all connected in one traceable digital thread.

## The Story

We want a toy eagle glider that can carry a Gandalf figure as its rider. Getting there involves the same steps as any real aerospace design effort, just at desk-toy scale:

1. **Define the requirements.** The eagle glider's design rules live in a SysML v2 model ([eagle_glider_requirements_3.sysml](files/eagle_glider_requirements_3.sysml)): a 196 mm wingspan, 8–15° of wing dihedral, an aspect ratio of at least 12, a centre of mass 30–40% aft of the nose, watertight manifold geometry, and more — covering physical, aerodynamic, structural, and even aesthetic requirements ("the silhouette shall be recognizable as an eagle").

2. **Model the rider.** [wizard_gandalf.step](files/wizard_gandalf.step) is the standalone Gandalf CAD model — the payload our glider has to carry.

3. **Put Gandalf on the eagle.** [eagle_glider_v24_gandalf_rider_v1.step](files/eagle_glider_v24_gandalf_rider_v1.step) is the first attempt at integrating the rider onto the glider. After design iteration, [eagle_glider_v24_gandalf_rider_vlast.step](files/eagle_glider_v24_gandalf_rider_vlast.step) is the latest revision of the same model. Having both lets you exercise versioning and version comparison: same model identity, two revisions, and a diff that shows exactly what changed.

4. **Check that it flies.** [eagle_v25_headwind.zip](files/eagle_v25_headwind.zip) is a complete OpenFOAM CFD case that simulates the glider in a 5 m/s headwind at roughly 15° incidence. It uses `snappyHexMesh` to mesh around the glider geometry, the `simpleFoam` steady-state solver with a k-ω SST turbulence model, and a `forceCoeffs` function that reports lift and drag coefficients on the glider every iteration. If the lift is there and the drag is reasonable, Gandalf flies.

## Files in This Repository

| File | Description |
|------|-------------|
| `wizard_gandalf.step` | The Gandalf rider CAD model |
| `eagle_glider_v24_gandalf_rider_v1.step` | First version of the eagle glider with Gandalf rider |
| `eagle_glider_v24_gandalf_rider_vlast.step` | Latest version of the eagle glider with Gandalf rider |
| `eagle_glider_requirements_3.sysml` | SysML v2 requirements model for the eagle glider |
| `eagle_v25_headwind.zip` | OpenFOAM CFD case: glider in a 5 m/s headwind, with lift/drag coefficient reporting |

All files are in the [files/](files/) folder.

## Using This Sample with Istari

Each file maps to a step in the Istari workflow:

- **Register** the CAD models as files in Istari, so each one gets a unique, traceable identity.
- **Version** the glider: upload `eagle_glider_v24_gandalf_rider_v1.step`, then add `eagle_glider_v24_gandalf_rider_vlast.step` as a new revision of the same model, and use the compare view to see how the design evolved.
- **Extract** structured data (geometry views, parameter tables, 3D previews) from the STEP files with a job such as FreeCAD's `@istari:extract`, so anyone on the team can inspect the design without CAD software.
- **Simulate** by running the OpenFOAM headwind case as a job, then review the resulting lift and drag coefficients against the requirements in the SysML model.

For a guided, click-by-click walkthrough of registering, extracting, versioning, and comparing files in the web app, see [docs/platform-101.md](docs/platform-101.md).
