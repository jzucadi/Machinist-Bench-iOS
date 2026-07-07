// RoseData.swift — Rose engine static data: presets, glossary, resources.
// Source: m7-extraction.md §8b (ROSE_PRESETS), §8c (glossary, resources).
// Core = Foundation only, public, Sendable.

import Foundation

// MARK: - RoseGlossaryRow

/// One row of the ornamental turning glossary.
/// Content verbatim from §8c ("Ornamental Turning — Quick Glossary").
public struct RoseGlossaryRow: Sendable {
    /// Term name.
    public let term: String
    /// Definition (verbatim from §8c).
    public let meaning: String

    public init(term: String, meaning: String) {
        self.term    = term
        self.meaning = meaning
    }
}

// MARK: - RoseData

/// Static data for the Rose Engine section.
public enum RoseData {

    // MARK: Presets

    /// Four built-in pattern presets.
    /// Verbatim from §8b ROSE_PRESETS (app-new.html lines 6384–6389):
    ///
    /// ```js
    /// const ROSE_PRESETS = [
    ///   ["Simple rose",      { lobes:"6",  wf:"sine",  amp:10, passes:"1",  step:0,   ph:"same",   spiral:18 }],
    ///   ["Phased spikes",    { lobes:"12", wf:"sine",  amp:8,  passes:"2",  step:0,   ph:"half",   spiral:18 }],
    ///   ["Basketweave band", { lobes:"12", wf:"sine",  amp:4,  passes:"28", step:1.2, ph:"half",   spiral:18 }],
    ///   ["Moiré spiral",     { lobes:"8",  wf:"puffy", amp:6,  passes:"36", step:0.9, ph:"spiral", spiral:18 }],
    /// ];
    /// ```
    ///
    /// Note: "Moiré" is stored as `"Moir\xE9 spiral"` in source; rendered here as "Moiré spiral".
    public static let presets: [(name: String, params: RoseParams)] = [
        (
            name: "Simple rose",
            params: RoseParams(
                lobes:        6,
                wave:         .sine,
                amplitudePct: 10.0,
                passes:       1,
                stepPct:      0.0,
                phase:        .same,
                spiralPct:    18.0
            )
        ),
        (
            name: "Phased spikes",
            params: RoseParams(
                lobes:        12,
                wave:         .sine,
                amplitudePct: 8.0,
                passes:       2,
                stepPct:      0.0,
                phase:        .halfLobe,
                spiralPct:    18.0
            )
        ),
        (
            name: "Basketweave band",
            params: RoseParams(
                lobes:        12,
                wave:         .sine,
                amplitudePct: 4.0,
                passes:       28,
                stepPct:      1.2,
                phase:        .halfLobe,
                spiralPct:    18.0
            )
        ),
        (
            name: "Moir\u{E9} spiral",         // "Moiré spiral" — §8b note
            params: RoseParams(
                lobes:        8,
                wave:         .puffy,
                amplitudePct: 6.0,
                passes:       36,
                stepPct:      0.9,
                phase:        .spiral,
                spiralPct:    18.0
            )
        ),
    ]

    // MARK: Glossary

    /// Ornamental turning quick glossary.
    /// Nine rows verbatim from §8c (Collapse "Ornamental Turning — Quick Glossary").
    public static let glossary: [RoseGlossaryRow] = [
        RoseGlossaryRow(
            term: "Rosette",
            meaning: "The wavy-edged cam on the headstock; its lobes are the pattern. \"Puffy 6\" = six rounded bumps."
        ),
        RoseGlossaryRow(
            term: "Rubber",
            meaning: "The follower that rides the rosette edge; where it touches sets pattern amplitude."
        ),
        RoseGlossaryRow(
            term: "Rocking",
            meaning: "Headstock swings side-to-side following the rosette — patterns on a face."
        ),
        RoseGlossaryRow(
            term: "Pumping",
            meaning: "Headstock slides axially instead — the same pattern on a dome, curve, or box lid."
        ),
        RoseGlossaryRow(
            term: "Phasing",
            meaning: "Rotating the rosette relative to the work between cuts; half a lobe turns waves into spikes or weave."
        ),
        RoseGlossaryRow(
            term: "Cutting frame",
            meaning: "Rotating cutter held in the slide rest — universal (UCF), eccentric (ECF), horizontal, or a drilling frame as on Plumier's No. 1636."
        ),
        RoseGlossaryRow(
            term: "Fixed cutter",
            meaning: "A non-rotating tool the moving work is drawn across — the simplest setup, where the rosette motion alone shapes each pass (a cutting frame instead spins its own cutter)."
        ),
        RoseGlossaryRow(
            term: "Geometric / eccentric chuck",
            meaning: "Mounts the work off-centre or on cross-slides so the cutter — not the spindle — generates the figure: epicyclic rosettes, stars, baskets."
        ),
        RoseGlossaryRow(
            term: "Division plate",
            meaning: "Indexes the spindle for equally-spaced work — the Holtzapffel rows (96 · 112 · 120 · 144 · 180 · 192 · 360) live in the Dividing Head's Ornamental mode."
        ),
    ]

    // MARK: Resources

    /// Ornamental turning resources.
    /// Seven entries verbatim from §8c (Collapse "Ornamental Turning — Resources").
    /// Rendered as links with `color: S.teal` inside a Note component.
    public static let resources: [(name: String, url: String)] = [
        (name: "Plumier Foundation",           url: "https://plumier.org/resources/"),
        (name: "holtzapffel.org",              url: "http://www.holtzapffel.org"),
        (name: "ornamentalturning.net",        url: "http://www.ornamentalturning.net"),
        (name: "OT Book of Knowledge",         url: "http://www.otbok.info"),
        (name: "Lindow Machine Works",         url: "http://www.lindowmachine.com"),
        (name: "billooms.com",                 url: "https://www.billooms.com"),
        (name: "Society of Ornamental Turners", url: "http://www.the-sot.com"),
    ]
}
