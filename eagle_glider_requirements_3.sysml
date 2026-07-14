/**
 * Eagle Glider SysML v2 Requirements Model
 * Tool: SysML v2 Pilot Implementation (KerML/SysML v2 textual notation)
 * Standard: OMG SysML v2 (ptc/2023-02-02)
 */

package EagleGliderRequirements {

    // ── Imports ────────────────────────────────────────────────────────────────
    import ScalarValues::*;
    import SI::*;

    // ══════════════════════════════════════════════════════════════════════════
    // PART DEFINITIONS
    // ══════════════════════════════════════════════════════════════════════════

    part def EagleGlider {
        part body       : Body;
        part leftWing   : Wing;
        part rightWing  : Wing;
        part tailFan    : TailFan;
        part dorsalFin  : DorsalFin;
        part beak       : Beak;
        part head       : Head;
    }

    part def Body;
    part def Wing;
    part def TailFan;
    part def DorsalFin;
    part def Beak;
    part def Head;

    // ══════════════════════════════════════════════════════════════════════════
    // ATTRIBUTE DEFINITIONS (measurable parameters)
    // ══════════════════════════════════════════════════════════════════════════

    attribute def Wingspan          { value : Real; }
    attribute def TotalLength       { value : Real; }
    attribute def MaxBodyHeight     { value : Real; }
    attribute def WingSpan          { value : Real; }
    attribute def DihedralAngle     { value : Real; }
    attribute def LeadingEdgeSweep  { value : Real; }
    attribute def AspectRatio       { value : Real; }
    attribute def TailFanRootWidth  { value : Real; }
    attribute def TailFanTipWidth   { value : Real; }
    attribute def TailFanPitch      { value : Real; }
    attribute def DorsalFinHeight   { value : Real; }
    attribute def MinWallThickness  { value : Real; }
    attribute def ComponentOverlap  { value : Real; }
    attribute def TriangleCount     { value : Integer; }

    // ══════════════════════════════════════════════════════════════════════════
    // CONSTRAINT DEFINITIONS (aerodynamic & geometric rules)
    // ══════════════════════════════════════════════════════════════════════════

    constraint def TailFanSpreadRatio {
        doc /* Tip must be at least 1.5× root width for pitch stability */
        in tipWidth  : Real;
        in rootWidth : Real;
        tipWidth >= 1.5 * rootWidth
    }

    constraint def AspectRatioMinimum {
        doc /* Minimum AR for efficient glide */
        in span  : Real;
        in chord : Real;
        (span / chord) >= 12.0
    }

    constraint def CentreOfMassRange {
        doc /* CoM must lie 30–40% aft of nose for stable nose-heavy trim */
        in comPosition  : Real;  // % from nose
        comPosition >= 30.0 & comPosition <= 40.0
    }

    constraint def DihedralRange {
        doc /* Dihedral 8–15° for roll stability without excessive drag */
        in angle : Real;  // degrees
        angle >= 8.0 & angle <= 15.0
    }

    constraint def SweepLimit {
        doc /* Max leading edge sweep 5mm at full span — prevents rearward Ac shift */
        in tipSweepOffset : Real;  // mm
        tipSweepOffset <= 5.0
    }

    // ══════════════════════════════════════════════════════════════════════════
    // REQUIREMENT DEFINITIONS
    // ══════════════════════════════════════════════════════════════════════════

    // ── 1. Physical Requirements ───────────────────────────────────────────────

    requirement def <'REQ-PHY-001'> WingspanRequirement {
        doc /* The glider wingspan shall be 196 mm ± 2 mm */
        subject glider : EagleGlider;
        attribute wingspan : Wingspan;
        require constraint { wingspan.value >= 194.0 & wingspan.value <= 198.0 }
    }

    requirement def <'REQ-PHY-002'> TotalLengthRequirement {
        doc /* The glider total length shall be 84 mm ± 2 mm */
        subject glider : EagleGlider;
        attribute len : TotalLength;
        require constraint { len.value >= 82.0 & len.value <= 86.0 }
    }

    requirement def <'REQ-PHY-003'> MaxBodyHeightRequirement {
        doc /* Maximum body height shall not exceed 20 mm */
        subject glider : EagleGlider;
        attribute h : MaxBodyHeight;
        require constraint { h.value <= 20.0 }
    }

    requirement def <'REQ-PHY-004'> WatertightMeshRequirement {
        doc /* All geometry shall form closed watertight manifold solids.
               No open edges, non-manifold geometry, or inverted normals shall exist.
               Verified by STL validation returning 0 bad triangles. */
        subject glider : EagleGlider;
    }

    requirement def <'REQ-PHY-005'> ComponentOverlapRequirement {
        doc /* All adjacent component joints shall overlap by a minimum of 2.0 mm
               to ensure structural continuity through the printed material. */
        subject glider : EagleGlider;
        attribute overlap : ComponentOverlap;
        require constraint { overlap.value >= 2.0 }
    }

    requirement def <'REQ-PHY-006'> MinWallThicknessRequirement {
        doc /* Minimum cross-section half-dimension at any station shall be ≥ 0.5 mm
               to ensure printability on FDM printers with 0.4 mm nozzle. */
        subject glider : EagleGlider;
        attribute t : MinWallThickness;
        require constraint { t.value >= 0.5 }
    }

    requirement def <'REQ-PHY-007'> SingleManifoldSolidRequirement {
        doc /* The model shall export as a single manifold solid body in both
               STEP AP214 and binary STL formats. */
        subject glider : EagleGlider;
    }

    // ── 2. Aerodynamic Requirements ────────────────────────────────────────────

    requirement def <'REQ-AERO-001'> DihedralRequirement {
        doc /* The wing shall have a continuous dihedral angle between 8° and 15°
               applied progressively from root to tip via a sine-curve profile.
               No abrupt kink transitions are permitted. */
        subject wing : Wing;
        attribute dihedral : DihedralAngle;
        require constraint DihedralRange { in angle = dihedral.value; }
    }

    requirement def <'REQ-AERO-002'> CamberedWingRequirement {
        doc /* Wing cross-sections shall be aerodynamically cambered:
               - Upper surface shall be convex with up to 18% additional camber
                 near the leading edge.
               - Lower surface shall be compressed to no more than 60% of upper
                 surface height (flat-bottomed profile).
               Symmetric elliptical cross-sections are explicitly not permitted. */
        subject wing : Wing;
    }

    requirement def <'REQ-AERO-003'> SweepRequirement {
        doc /* Wing leading edge sweep shall not exceed 5 mm offset at full span.
               Excessive sweep shifts the aerodynamic centre rearward causing
               pitch instability in hand-launched foam gliders. */
        subject wing : Wing;
        attribute sweep : LeadingEdgeSweep;
        require constraint SweepLimit { in tipSweepOffset = sweep.value; }
    }

    requirement def <'REQ-AERO-004'> WingPositionRequirement {
        doc /* The wing root leading edge shall be positioned at least 5 mm
               forward of the body maximum cross-section (y = 0) to align the
               centre of lift with the expected centre of mass. */
        subject wing : Wing;
    }

    requirement def <'REQ-AERO-005'> AspectRatioRequirement {
        doc /* The main wing aspect ratio (span² / area) shall be ≥ 12 to
               ensure adequate lift-to-drag ratio for gliding flight. */
        subject wing : Wing;
        attribute ar : AspectRatio;
        require constraint AspectRatioMinimum {
            in span  = 196.0;
            in chord = ar.value;
        }
    }

    requirement def <'REQ-AERO-006'> TailFanSpreadRequirement {
        doc /* The tail fan tip width shall be at least 1.5× the root width.
               This ensures the fan generates sufficient restoring moment for
               pitch stability. */
        subject fan : TailFan;
        attribute rootW : TailFanRootWidth;
        attribute tipW  : TailFanTipWidth;
        require constraint TailFanSpreadRatio {
            in tipWidth  = tipW.value;
            in rootWidth = rootW.value;
        }
    }

    requirement def <'REQ-AERO-007'> TailFanPitchRequirement {
        doc /* The tail fan shall have a positive pitch incidence of 2.0–3.0 mm
               measured as the vertical rise from root to tip station.
               This provides nose-up pitch trim to counteract the nose-heavy
               centre of mass. */
        subject fan : TailFan;
        attribute pitch : TailFanPitch;
        require constraint { pitch.value >= 2.0 & pitch.value <= 3.0 }
    }

    requirement def <'REQ-AERO-008'> DorsalFinHeightRequirement {
        doc /* The dorsal fin shall have a minimum height of 3.5 mm at its
               tallest cross-section to provide adequate yaw stability. */
        subject fin : DorsalFin;
        attribute h : DorsalFinHeight;
        require constraint { h.value >= 3.5 }
    }

    requirement def <'REQ-AERO-009'> DorsalFinTaperRequirement {
        doc /* The dorsal fin trailing edge shall taper smoothly into the tail
               fan surface. No abrupt cutoff is permitted. The fin cross-section
               half-height shall reduce monotonically over the final 13 mm to
               a value ≤ 0.2 mm where it meets the fan surface. */
        subject fin : DorsalFin;
    }

    requirement def <'REQ-AERO-010'> CentreOfMassRequirement {
        doc /* The glider centre of mass shall lie between 30% and 40% of total
               length aft of the nose tip when manufactured from uniform density
               foam. If balance is outside this range, ballast shall be added to
               the beak (nose-heavy correction) or tail fan edge (tail-heavy
               correction) before flight. */
        subject glider : EagleGlider;
        require constraint CentreOfMassRange {
            in comPosition = 35.0;  // nominal design target: 35% from nose
        }
    }

    requirement def <'REQ-AERO-011'> FusiformBodyRequirement {
        doc /* The body cross-section shall follow a smooth fusiform (teardrop)
               profile with no abrupt width or height transitions between
               adjacent loft stations. All station-to-station rx and rz
               changes shall be monotonic within each taper zone. */
        subject body : Body;
    }

    // ── 3. Structural Requirements ─────────────────────────────────────────────

    requirement def <'REQ-STR-001'> BeakMassRequirement {
        doc /* The beak geometry shall be sufficiently voluminous to place the
               glider centre of mass within the range defined by REQ-AERO-010
               when manufactured from uniform density foam.
               Minimum beak root cross-section half-radius: 2.5 mm. */
        subject beak : Beak;
        refines REQ-AERO-010;
    }

    requirement def <'REQ-STR-002'> BeakTipRequirement {
        doc /* The beak shall taper to a minimum tip cross-section of 0.03 mm
               half-radius. The hook shall follow a parabolic downward curve
               with a minimum vertical drop of 7.0 mm from beak root to tip. */
        subject beak : Beak;
    }

    requirement def <'REQ-STR-003'> WingTipThicknessRequirement {
        doc /* Wing tip cross-section half-height shall be ≥ 0.12 mm to
               prevent breakage during foam handling and flight impact. */
        subject wing : Wing;
    }

    requirement def <'REQ-STR-004'> SmoothTransitionRequirement {
        doc /* All loft station transitions shall use smoothstep or sine-curve
               interpolation. Linear interpolation producing angular transitions
               is not permitted at any junction. This prevents stress
               concentrations in foam manufacture. */
        subject glider : EagleGlider;
    }

    requirement def <'REQ-STR-005'> TailFanRootBlendRequirement {
        doc /* The tail fan root width shall match the body tail cross-section
               width at the junction y-station within ± 0.5 mm to ensure
               structural continuity and eliminate sharp angular joints. */
        subject fan : TailFan;
        refines REQ-PHY-005;
    }

    // ── 4. Aesthetic Requirements ──────────────────────────────────────────────

    requirement def <'REQ-AES-001'> EagleSilhouetteRequirement {
        doc /* The glider top-view and side-view silhouettes shall be
               recognisable as a soaring bald eagle without supporting labels
               or context. */
        subject glider : EagleGlider;
    }

    requirement def <'REQ-AES-002'> HeadProfileRequirement {
        doc /* The head shall present a smooth rounded dome profile rising
               above the body centreline. The dome shall peak at no more than
               3.8 mm above the body centre z-axis and shall not have a
               flat-topped or angular crown. */
        subject head : Head;
    }

    requirement def <'REQ-AES-003'> BeakProfileRequirement {
        doc /* The beak shall follow a parabolic downward curve from root to tip.
               The hook shall be concentrated at the distal end (final 30% of
               beak length). The beak shall not be straight, upturned, or
               blunt-ended. */
        subject beak : Beak;
    }

    requirement def <'REQ-AES-004'> WingPlanformRequirement {
        doc /* Wing planform shall be consistent with a soaring raptor:
               broad root chord, continuous taper to tip, slight leading-edge
               sweep. Rectangular or delta planforms are not acceptable. */
        subject wing : Wing;
    }

    requirement def <'REQ-AES-005'> TailFanProfileRequirement {
        doc /* The tail fan shall spread wider at the tip than at the root,
               consistent with a fanned eagle tail in soaring posture. */
        subject fan : TailFan;
        refines REQ-AERO-006;
    }

    requirement def <'REQ-AES-006'> DorsalFinAestheticRequirement {
        doc /* The dorsal fin shall taper into the tail fan surface in a manner
               consistent with a raised central tail feather. Aircraft-style
               rectangular or trapezoidal fin shapes are not acceptable. */
        subject fin : DorsalFin;
        refines REQ-AERO-009;
    }

    requirement def <'REQ-AES-007'> SeamlessBlendRequirement {
        doc /* No visible seams or abrupt surface discontinuities shall be
               present at any component boundary. All transitions shall be
               smooth and continuous to maintain the organic appearance of a
               living bird. */
        subject glider : EagleGlider;
        refines REQ-STR-004;
    }

    // ── 5. Manufacturing Requirements ──────────────────────────────────────────

    requirement def <'REQ-MFG-001'> StepExportRequirement {
        doc /* The model shall export as a valid STEP AP214 file
               (ISO 10303-21, schema AUTOMOTIVE_DESIGN).
               The file shall contain a single MANIFOLD_SOLID_BREP within
               a CLOSED_SHELL. */
        subject glider : EagleGlider;
    }

    requirement def <'REQ-MFG-002'> StlExportRequirement {
        doc /* The model shall export as a valid binary STL file.
               All triangle normals shall be correctly oriented outward.
               Zero degenerate or NaN triangles shall be present. */
        subject glider : EagleGlider;
    }

    requirement def <'REQ-MFG-003'> FoamCuttingRequirement {
        doc /* The model geometry shall be suitable for cutting from
               6–10 mm closed-cell foam sheet using a hot wire or bandsaw.
               The beak hook and wingtips require support material or careful
               post-processing and are acknowledged as delicate features. */
        subject glider : EagleGlider;
    }

    requirement def <'REQ-MFG-004'> FDMPrintRequirement {
        doc /* The model shall be printable on FDM printers with 0.4 mm nozzle
               and 0.2 mm layer height. Supports are required for the beak
               hook (overhang > 45°). All other surfaces shall print without
               supports when oriented with the wing plane horizontal. */
        subject glider : EagleGlider;
    }

    requirement def <'REQ-MFG-005'> TriangleBudgetRequirement {
        doc /* Total STL triangle count shall not exceed 10,000 to ensure
               reasonable slicer performance and file size. */
        subject glider : EagleGlider;
        attribute count : TriangleCount;
        require constraint { count <= 10000 }
    }

    // ══════════════════════════════════════════════════════════════════════════
    // REQUIREMENT USAGE (instantiated on EagleGlider)
    // ══════════════════════════════════════════════════════════════════════════

    requirement <'RQTU-001'> : WingspanRequirement {
        subject glider : EagleGlider;
    }

    requirement <'RQTU-002'> : DihedralRequirement {
        subject wing : Wing;
    }

    requirement <'RQTU-003'> : CamberedWingRequirement {
        subject wing : Wing;
    }

    requirement <'RQTU-004'> : TailFanPitchRequirement {
        subject fan : TailFan;
    }

    requirement <'RQTU-005'> : CentreOfMassRequirement {
        subject glider : EagleGlider;
    }

    // ══════════════════════════════════════════════════════════════════════════
    // SATISFY RELATIONSHIPS
    // (maps design elements to requirements they fulfil)
    // ══════════════════════════════════════════════════════════════════════════

    satisfy REQ-PHY-004 by EagleGlider {
        doc /* All loft_rings() calls produce closed manifold surfaces verified
               by STL validation returning 0 bad triangles. OVERLAP = 2.0 mm
               enforced globally. */
    }

    satisfy REQ-AERO-001 by Wing {
        doc /* Dihedral z-offset follows sin(t·π/2)^1.5 curve from 0 to 14 mm
               across full span, verified at xs=90 mm: z ≥ 14 mm. */
    }

    satisfy REQ-AERO-002 by Wing {
        doc /* Wing ring function: sin(a) < 0 compressed to 0.55×, sin(a) > 0
               has 1.18× camber boost. Implemented in ering() function. */
    }

    satisfy REQ-AERO-003 by Wing {
        doc /* max_sweep = 5.0 mm; ys = -5.0*t + 5.0 (root offset +5, tip 0).
               Net trailing offset at tip = 5 mm. */
    }

    satisfy REQ-AERO-004 by Wing {
        doc /* Wing root y-offset = +5 mm (forward of body widest point y=0). */
    }

    satisfy REQ-AERO-007 by TailFan {
        doc /* tail fan tip cz = root_cz + 2.5 mm (pitch = 2.5 mm). */
    }

    satisfy REQ-AERO-009 by DorsalFin {
        doc /* Fin tapers from peak rz=3.8 mm at y=-30.5 to rz=0.12 mm at
               y=-43.5 over 13 mm, then merges into fan surface. */
    }

    satisfy REQ-PHY-005 by EagleGlider {
        doc /* OVERLAP constant = 2.0 mm applied at all component junctions
               throughout the generative script. */
    }

    satisfy REQ-MFG-005 by EagleGlider {
        doc /* Current triangle count: 5,192 (well within 10,000 budget). */
    }

    // ══════════════════════════════════════════════════════════════════════════
    // VERIFY RELATIONSHIPS
    // (defines how each requirement is verified)
    // ══════════════════════════════════════════════════════════════════════════

    verification def STLValidation {
        doc /* Load STL, iterate all triangles, check for NaN normals,
               degenerate triangles, and open edges. Pass = 0 errors. */
    }

    verification def PhysicalMeasurement {
        doc /* Measure printed/cut part with calipers. */
    }

    verification def BalanceTest {
        doc /* Hold glider between two fingers under the wings.
               Pass = very slight nose-down tendency with no ballast added. */
    }

    verification def FlightTest {
        doc /* Throw with smooth level push at waist height.
               Pass = sustained glide ≥ 3 m with no immediate stall or dive. */
    }

    verify REQ-PHY-001 by PhysicalMeasurement;
    verify REQ-PHY-002 by PhysicalMeasurement;
    verify REQ-PHY-003 by PhysicalMeasurement;
    verify REQ-PHY-004 by STLValidation;
    verify REQ-PHY-005 by STLValidation;
    verify REQ-PHY-006 by STLValidation;
    verify REQ-AERO-001 by PhysicalMeasurement;
    verify REQ-AERO-007 by PhysicalMeasurement;
    verify REQ-AERO-008 by PhysicalMeasurement;
    verify REQ-AERO-010 by BalanceTest;
    verify REQ-MFG-005 by STLValidation;

    // ══════════════════════════════════════════════════════════════════════════
    // USE CASE: ThrowAndGlide
    // ══════════════════════════════════════════════════════════════════════════

    use case def ThrowAndGlide {
        doc /* Primary use case: human throws foam glider in level flight */

        subject glider : EagleGlider;
        actor thrower  : Person;

        objective {
            doc /* Glider shall sustain stable gliding flight for ≥ 3 m
                   after a smooth level hand launch at waist height. */
        }

        include ThrowAndGlide::verifyBalance;
        include ThrowAndGlide::steadyGlide;
        include ThrowAndGlide::trimAdjustment;
    }

    action def VerifyBalance {
        doc /* Hold glider under wings. Verify slight nose-down tendency.
               Add clay to beak if tail-heavy; add clay to tail fan if
               excessively nose-heavy. */
    }

    action def SteadyGlide {
        doc /* Deliver smooth level push. Glider enters stable glide.
               Dihedral corrects roll. Tail fan maintains pitch.
               Dorsal fin maintains heading. */
    }

    action def TrimAdjustment {
        doc /* Alternative: if glider nose-dives, bend tail fan trailing
               edge up 1–2 mm or add 0.5 g clay to tail fan edge.
               If glider stalls, add 0.5 g clay to beak tip. */
    }

}
