---
sidebar_position: 1
title: 101 - Web app basics
---

# Web app 101: Your First Digital Thread

In this tutorial you use the **Istari Digital web app** to build a small but complete **digital thread**: a traceable chain from an engineering file through its extracted data and a subsequent design revision. You will do so using only your browser, no code, no command line.

The scenario: you want a little plastic wizard figure for a game you are playing, and need to know its size, shape, components, and polygons. You will register that spreadsheet in the web app, extract structured data from it, upload a revised version after a design change, re-extract, and compare the results.

By the end you will understand:

- How files are **registered** in the Istari Digital Platform and why registration matters
- How **functions** and **jobs** turn raw files into structured, shareable resources
- How **versioning** tracks design changes without losing history
- How to **compare** extracted data between revisions to see exactly what changed

**Time:** ~15 minutes.

## Prerequisites

- An Istari Digital Platform account. If you don't have one yet, follow the [Sign-up Guide](../../users/account/sign-up.md).
- An **organization administrator** must complete [Onboard your organization](../org-admin/onboard-your-organization.md) first — your environment needs a connected agent with CAD and your account needs **tool access** for `@istari:extract`.

Download these two files to your computer — they are versions of the same CAD models:

- <a href="https://github.com/Istari-digital/istari-gandolf/raw/main/wizard_gandalf.step" download target="_blank" rel="noopener noreferrer">wizard_gandalf.step (v1)</a>
- <a href="https://github.com/Istari-digital/istari-gandolf/raw/main/eagle_glider_v24_gandalf_rider_vlast.step" download target="_blank" rel="noopener noreferrer">eagle_glider_v24_gandalf_rider.step (latest)</a>

:::info What's in the file?
The CAD model is a wizard, with weight, volume, shape, components, and polygons listed.
:::

---

## Step 1 — Register your first file

Every engineering workflow on the Istari Digital Platform starts with **registration**. When you upload a file, the Istari Digital Platform gives it a unique identity (a UUID) so it can be versioned, shared, and used as input for jobs. To learn more about how registration works, see [Resources](../../intro/key-concepts/resources.md).

That UUID is the anchor of your digital thread. Every extraction, every revision, every share event links back to the same registered identity. In fact, everything in the Istari Digital Platform has a UUID — files, jobs, resources, revisions, systems. This means every action is traceable: you can always answer _who changed what, when, and what was produced from it_. When AI agents or automated workflows operate on your data, these UUIDs are the safeguard — they provide an auditable record of exactly which inputs the AI used and which outputs it produced.

1. Sign in to the web app and click **Files** in the left sidebar.
2. Click **Add files** (or drag and drop) and select `wizard_gandolf_v1.step` from your computer.
3. In the upload dialog, check the **File name** — the web app pre-fills it from the file name. You can leave **External Version** and **Tags** empty for now.
4. Click **Upload**.

Once the upload completes, the file appears in your file list. Click it to open the file detail view. Open the **details panel** on the right (click the details icon in the top-right action bar if it is hidden). You will see metadata the web app created for you: the **File ID** (a UUID), **Revision ID**, creation date, and owner. This file is now a **model** — a registered file that can be used as input for Istari Digital Platform functions. Later, when you upload a revised version, the File ID stays the same — only a new revision is added. This is how the Istari Digital Platform maintains a complete history without losing the identity.

## Step 2 — Extract structured data

Your CAD model is full of valuable data — polygons, scale, component shapes — but it is locked inside a file format that requires specific software to open. In this tutorial we use a step file that you could open in FreeCAD, but in real projects the situation can vary. SysML models and simulation decks each require powerful, specialized tools whose licenses are typically limited to the teams that author the files. A program manager reviewing the design, a supplier checking an interface, or an AI agent running an automated workflow won't always have the right application installed.

This is where extraction changes the game. The Istari Digital Platform uses [integrations](../../intro/key-concepts/integrations.md) to reach into proprietary files and produce **vendor-neutral resources** — JSON, CSV, HTML, PDF, and 3D formats like OBJ. The licensed tool is used once, on the agent, during extraction. From that point on, everyone else on the project can work with the open resources without needing the original software. These open formats are also ideal inputs for automated workflows and AI agents, because structured JSON or CSV can be parsed by any programming language or LLM without proprietary SDKs.

Extraction is a **function** — a specific operation that an [agent](../../intro/key-concepts/integrations.md) executes on your file. The agent opens the file using the appropriate tool, pulls out structured data, and uploads the results as new **resources** attached to your model.

1. Click the **Create Job** button.
2. In the dialog, browse the list and select `FreeCAD` → `@istari:extract`.

   The dialog only displays the tools available for the type of file selected.
   Depending on the tool, the dialog may also show a **Version** selector and **Parameters** to configure. For `@istari:extract` on FreeCAD, there is nothing extra to fill in. Under **Advanced Options** you can pick a specific **Agent** or **Agent Pool** — leave this on Automatic for now; we will cover agent pools in a later tutorial.

3. Click **Execute Function**.

The Istari Digital Platform creates a **job** — a tracked unit of work — and assigns it to an agent for execution.

## Step 3 — Wait for the job to complete

Every job follows a lifecycle: **Pending → Claimed → Validating → Running → Uploading → Completed**. The Istari Digital Platform manages this lifecycle; you follow progress in the web app in real time.

1. After clicking **Execute Function**, the **Activity** panel at the bottom of the center view shows your job. Watch the **Status** update as the agent picks up and processes the file.
2. Wait for the status to reach **Completed**. Depending on the file and the integration, this can take anywhere from a few seconds to several minutes.
3. Once completed, refresh the page in your browser to make sure the file tree is up to date. Then expand `wizard_gandolf_v1.step` in the left panel — you will see the job listed underneath, and below it the resources it produced.

:::tip
You can also monitor all your jobs from the **Jobs** page (click **Jobs** in the left sidebar). It lists every job you have started across all your models, with status, function name, tool, and timestamps — useful when you have multiple jobs running.
:::

## Step 4 — Explore the extracted resources

Once the job completes, the agent uploads the results as new resources attached to your model. Resources produced by a job are called **artifacts** — they are the vendor-neutral, readable outputs of an extraction. Like every other object in the Istari Digital Platform, each artifact has its own UUID and is fully traceable back to the job and model that produced it.

1. In the file tree, expand `wizard_gandolf_v1.step` to see the job and its output resources. Click any resource to preview it in the center panel.
2. The exact resources produced depend on the integration and the function you ran — a spreadsheet extraction produces CSVs and JSON, while a CAD extraction (e.g. Siemens NX) might produce PNG views, a 3D OBJ model, and a JSON parameter table. For a CAD model, FreeCAD's `@istari:extract` produces the following resources:
   - `metadata_report.json` — the polygon placement, and how polygons are placed, such as vertices. There are also details about the uploading and extraction.
   - `wizard_view.png` — a view of the module from a certain angle
   - `assembly_data.json` — where each polygon is, and the polygon count
   - `geometric_properties.json` — a rendered report of geometric properties
   - `wizard_geometry.obj` — a 3D rotatable model
   - `istari-module-stderr.txt` — timestamps and error logs of all actions taken with the model

3. Click any resource to preview it. The web app renders CSV, JSON, PDF, and HTML directly in the browser — no download or external software needed. Notice that you are viewing the contents of the CAD model without FreeCAD or any other tool installed on your machine. This is the vendor-neutral principle at work.

Because the output is plain JSON, any tool can consume it — a Python script, a web dashboard, an AI agent, or a CI/CD pipeline.

The same principle applies to every integration: a Cameo extraction produces JSON representations of SysML blocks, a Creo extraction produces geometry and parameter tables, a Nastran extraction produces simulation results.

4. To save any resource to your computer, select it and click **Download**.

## Step 5 — Upload a revised version

Engineering is iterative. After looking at it you might realize that you want a face on your wizard CAD model. Instead of uploading a completely new file, you upload a **new version** of the same model. This keeps the full history under one identity.

1. Select `wizard_gandolf_v1.step` in the file list.
2. Open the **details panel** on the right side of the screen. If it is hidden, click the details icon in the top-right action bar to toggle it open.
3. Scroll to the **Versions** section at the bottom of the details panel and click the **+** (Add version) button.
4. In the upload dialog, select `wizard_gandolf_v8.step` from your computer.
5. Click **Upload**.

The Istari Digital Platform adds a new **revision** to the same model. The UUID stays the same, but the revision history now shows two entries. Anyone with access to this file can see both versions and understand the progression.

:::tip
This is a core principle of the digital thread: every change is a new revision, not a new file. The model's identity — and everything linked to it (resources, jobs, sharing permissions, system memberships) — carries forward.
:::

## Step 6 — Extract the new version

Now let's extract data from the updated CAD model so we can compare what changed.

1. In the **Versions** section of the details panel, click the version you just uploaded to make it the active revision. The center view updates to show the new version.
2. Click **Create job** in the **Activity** panel at the bottom of the center view.
3. In the **Create Job** dialog, select the same tool and function as before: `FreeCAD` → `@istari:extract`.
4. Click **Execute Function** and wait for the status to reach **Completed**. Refresh the page once done.

You will now see a second set of resources under this model, produced by the new job.

## Step 7 — Compare what changed

Now for the payoff. You have two versions of the same CAD model and two sets of extracted data. The web app lets you see exactly what changed.

1. In the file detail view, click the **Compare versions** button (the arrow-left-right icon in the action bar). The **File Comparison** dialog opens.
2. Since the file only has two revisions, the dialog automatically selects v1 on the left and v2 on the right. When a file has more revisions, use the **left and right version selectors** at the top of the dialog to pick which two to compare.
3. Toggle between **Split** and **Unified** diff views.

The diff viewer highlights additions, deletions, and modifications. You can see at a glance which parameters changed, which components were updated, and which dimensions stayed the same.

This is the digital thread in action: a traceable, auditable record of how your design evolved from one version to the next.

## Step 8 (optional) — Clean up

If this was a practice run, you can tidy up your file list by archiving the tutorial file. The Istari Digital Platform is immutable — files are never deleted, so your data and its full history are always preserved. Archiving simply hides the file from the default view.

1. Select `wizard_gandolf_v1.step` in the file list.
2. Click the **Archive** button (box icon) in the action bar.
3. Confirm the action in the dialog.

The file disappears from the active list. You can always find it again by opening the **Filter files** panel and setting **Status** to **Archived** or **All**.

---

## What you learned

| Concept                | What happened                                                                                                                                                             |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **File registration**  | Uploading created a tracked model with a unique UUID. Your file content stayed in your own storage — the Istari Digital Platform only records metadata.                   |
| **Functions and jobs** | You ran `@istari:extract` — a function executed by an agent on your model. The job lifecycle (Pending → Completed) was fully tracked.                                     |
| **Resources**          | The extraction produced vendor-neutral resources (JSON, PNG, OBJ) from a proprietary format — readable by anyone, any tool, or any AI agent without specialized software. |
| **Versioning**         | Uploading a revised file added a new revision to the same model identity, preserving the full history.                                                                    |
| **Comparison**         | You compared extracted data across versions to see exactly what changed in the design.                                                                                    |

## What's next

You have just completed the fundamental Istari Digital Platform workflow in the web app: **register → extract → revise → compare**. Here is where to go from here:

- **Organize with Systems.** Group related files (CAD models, requirements spreadsheets, simulation inputs) into a system. Take snapshots to capture consistent, point-in-time states. Compare snapshots across design iterations. See the [Systems Guide](../../users/user-guide/systems.md).
- **Share with your team.** Share files or systems with teammates and assign roles (Viewer, Editor, Administrator). See [Sharing and Access](../../users/user-guide/sharing-and-access.md).
- **Automate with the Python client.** Everything you did in the browser can be scripted — upload files, run jobs, retrieve resources, and build automated pipelines that generate design options from extracted parameters. See the [Python Client Quick Start](../../developers/SDK/01-setup.md).
- **Explore more integrations.** FreeCAD is just the beginning. The Istari Digital Platform supports CAD tools (CATIA, Creo, NX), simulation solvers (NASTRAN, MATLAB), systems engineering tools (Cameo, SysML), and more. See [Supported Integrations](../../integrations/01-supported-integrations.md).
