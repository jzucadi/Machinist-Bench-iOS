import SwiftUI

/// Rose Engine section — schematic, Pattern Lab, glossary, resources.
/// Source: m7-extraction.md §8 (RoseEngine, app-new.html lines 6375–6616;
/// RoseEngineSVG lines 3400–3423). Accent: S.red throughout.
struct RoseEngineView: View {
    // Web defaults (§8b controls table): lobes "6", wf "sine", amp 10,
    // passes "1", step 0, ph "same", spiral 18 — identical to the
    // "Simple rose" preset.
    @State private var params: RoseParams = RoseData.presets[0].params

    // Collapse state: "How a Rose Engine Works" expanded by default (brief);
    // glossary and resources start collapsed like web Collapses.
    @State private var howExpanded = true
    @State private var glossaryExpanded = false
    @State private var resourcesExpanded = false

    var body: some View {
        // Pattern geometry recomputed on any parameter change — outside the
        // Canvas closure (brief requirement).
        let paths = RosePattern.paths(params)

        ScrollView {
            VStack(spacing: 16) {
                collapse("How a Rose Engine Works", expanded: $howExpanded) {
                    howItWorksContent
                }
                patternLab(paths)
                collapse("Ornamental Turning — Quick Glossary", expanded: $glossaryExpanded) {
                    DataTable(
                        columns: ["Term", "Meaning"],
                        rows: RoseData.glossary.map { [$0.term, $0.meaning] },
                        accent: .red
                    )
                }
                collapse("Ornamental Turning — Resources", expanded: $resourcesExpanded) {
                    resourcesContent
                }
            }
            .padding(16)
        }
        .background(Catppuccin.base)
        .unitToolbar()
    }

    // MARK: - How a Rose Engine Works (§8a schematic + §8c prose)

    @ViewBuilder private var howItWorksContent: some View {
        // Web: div background S.inset, borderRadius 12, padding 14px 10px,
        // border 1px solid S.line2.
        DiagramCanvas(viewBox: CGRect(x: -60, y: 0, width: 480, height: 220)) { svg in
            Self.drawSchematic(svg)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 14)
        .background(Catppuccin.mantle, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Catppuccin.surface1, lineWidth: 1))

        // §8c how-it-works paragraph (verbatim; *italic* / **bold** per web).
        Self.rich("A rose engine lathe makes decorative patterns by letting the workpiece *move* against a fixed cutter. A shaped cam — the **rosette** — is mounted on the spindle. As the spindle turns, a follower (the **rubber**) rides the rosette's lobed edge and rocks or pumps the whole headstock. A stationary cutter then traces that motion into the surface, so the lobe pattern of the rosette is reproduced as guilloché on the work.")
            .font(AppFont.body(13))
            .foregroundStyle(Catppuccin.subtext0)
            .frame(maxWidth: .infinity, alignment: .leading)

        // §8c guilloché note (verbatim).
        NoteView(tone: .info, text: "Closely related to engine-turning (guilloché) used on watch dials and fine metalwork. The same principle — a master cam plus a follower modulating the work's motion — underlies straight-line engines and the brocading on bank-note plates.")
    }

    /// §8a RoseEngineSVG — 16 primitives, exact render order, raw viewBox coords.
    /// Constants (exact JS): cx=120, cy=110, base=58, amp=12, lobes=8.
    private static func drawSchematic(_ svg: SVGContext) {
        let cx = 120.0, cy = 110.0, base = 58.0, amp = 12.0, lobes = 8.0

        // 1. Spindle center: circle cx=120 cy=110 r=6 fill=S.mut2
        svg.circle(cx: cx, cy: cy, r: 6, fill: Catppuccin.overlay0)

        // 2. Rosette (8-lobe cam): 121 pts, fill S.violet+"18", stroke S.violet w=2
        var rosette = Path()
        for i in 0...120 {
            let t = Double(i) / 120.0 * 2.0 * .pi
            let r = base + amp * cos(lobes * t)
            let pt = CGPoint(x: cx + r * cos(t), y: cy + r * sin(t))
            if i == 0 { rosette.move(to: pt) } else { rosette.addLine(to: pt) }
        }
        rosette.closeSubpath()
        svg.path(rosette, fill: Catppuccin.mauve.opacity(0.09),
                 stroke: Catppuccin.mauve, width: 2)

        // 3. "spindle" text: x=120 y=113 (cy+3) fill=S.ink F.mono size=8 middle
        svg.text("spindle", x: cx, y: cy + 3, size: 8,
                 color: Catppuccin.text, mono: true, anchor: .middle)

        // 4. SvgLabel "rosette (cam) on spindle" x=120 y=32 (cy−base−amp−8) S.violet size=9
        svg.text("rosette (cam) on spindle", x: cx, y: cy - base - amp - 8, size: 9,
                 color: Catppuccin.mauve, mono: true, anchor: .middle, weight: .semibold)

        // 5. Rubber IIFE — t=0 → r=70, rx=190, ry=110:
        //    rect x=192 (rx+2) y=104 (ry−6) w=40 h=12 rx=2, S.amber+"33" fill, S.amber stroke 1.4
        svg.roundedRect(CGRect(x: 192, y: 104, width: 40, height: 12), cornerRadius: 2,
                        fill: Catppuccin.peach.opacity(0.20),
                        stroke: Catppuccin.peach, width: 1.4)
        //    follower contact: circle cx=192 cy=110 r=3.5 fill=S.amber
        svg.circle(cx: 192, cy: 110, r: 3.5, fill: Catppuccin.peach)
        //    SvgLabel "rubber" x=240 (rx+50) y=100 (ry−10) S.amber size=9 start
        svg.text("rubber", x: 240, y: 100, size: 9,
                 color: Catppuccin.peach, mono: true, anchor: .start, weight: .semibold)

        // 6. Rocking arc: M 44 84 A 30 30 0 0 1 44 136, S.green stroke 1.6
        let arc = svgArcPath(from: CGPoint(x: 44, y: 84), to: CGPoint(x: 44, y: 136),
                             r: 30, largeArc: false, sweep: true)
        svg.path(arc, stroke: Catppuccin.green, width: 1.6)

        // 7. Upper arrowhead: 44,84 39,89 49,90 fill=S.green
        svg.poly([CGPoint(x: 44, y: 84), CGPoint(x: 39, y: 89), CGPoint(x: 49, y: 90)],
                 fill: Catppuccin.green)

        // 8. Lower arrowhead: 44,136 39,131 49,130 fill=S.green
        svg.poly([CGPoint(x: 44, y: 136), CGPoint(x: 39, y: 131), CGPoint(x: 49, y: 130)],
                 fill: Catppuccin.green)

        // 9. SvgLabel "head rocks" x=20 (cx−base−amp−30) y=113 (cy+3) S.green size=8.5 end
        svg.text("head rocks", x: 20, y: cy + 3, size: 8.5,
                 color: Catppuccin.green, mono: true, anchor: .end, weight: .semibold)

        // 10. Work block: rect x=300 y=76 (cy−34) w=70 h=68 rx=3, S.panel2 fill, S.mut stroke 1.2
        svg.roundedRect(CGRect(x: 300, y: 76, width: 70, height: 68), cornerRadius: 3,
                        fill: Catppuccin.surface0,
                        stroke: Catppuccin.overlay1, width: 1.2)

        // 11. SvgLabel "work" x=335 y=70 (cy−40) S.mut size=9 middle
        svg.text("work", x: 335, y: cy - 40, size: 9,
                 color: Catppuccin.overlay1, mono: true, anchor: .middle, weight: .semibold)

        // 12. Wavy surface: M300,90 then 71 pts (2 sine cycles x=300..370), S.teal stroke 1.6
        var wavy = Path()
        wavy.move(to: CGPoint(x: 300, y: cy - 20))
        for i in 0...70 {
            let x = 300.0 + Double(i)
            let yy = cy - 20 + 3 * sin(Double(i) / 70.0 * 4.0 * .pi)
            wavy.addLine(to: CGPoint(x: x, y: yy))
        }
        svg.path(wavy, stroke: Catppuccin.teal, width: 1.6)

        // 13. Cutter arrowhead: 372,90 384,85 384,95 fill=S.teal
        svg.poly([CGPoint(x: 372, y: 90), CGPoint(x: 384, y: 85), CGPoint(x: 384, y: 95)],
                 fill: Catppuccin.teal)

        // 14. SvgLabel "fixed cutter" x=390 y=92 (cy−18) S.teal size=8.5 start
        svg.text("fixed cutter", x: 390, y: cy - 18, size: 8.5,
                 color: Catppuccin.teal, mono: true, anchor: .start, weight: .semibold)
    }

    // MARK: - Pattern Lab (§8b)

    private func patternLab(_ paths: [[CGPoint]]) -> some View {
        Panel(title: "Rose Engine Pattern Lab", accent: .red,
              subtitle: "preview the cut before you set the rosette") {
            // Preset buttons (4, from RoseData.presets) — applying sets all params.
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 8)], spacing: 8) {
                ForEach(RoseData.presets.indices, id: \.self) { i in
                    let preset = RoseData.presets[i]
                    Button { params = preset.params } label: {
                        Text(preset.name)
                            .font(AppFont.display(12))
                            .tracking(0.5)
                            .foregroundStyle(Catppuccin.overlay0)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Catppuccin.surface1, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }

            // Controls (§8b table).
            Field(label: "Rosette Lobes", hint: "Puffy 6 → 6") {
                NumberInput(value: lobesBinding, step: 1, accent: .red)
            }
            Field(label: "Waveform", hint: "idealized profiles") {
                Segmented(selection: $params.wave,
                          options: RoseWave.allCases.map { ($0, $0.displayName) },
                          accent: .red)
            }
            Field(label: "Amplitude", hint: "\(Self.num(params.amplitudePct))% of radius") {
                Slider(value: $params.amplitudePct, in: 1...25, step: 1)
                    .tint(Catppuccin.red)
            }
            Field(label: "Passes", hint: "cuts in the band") {
                NumberInput(value: passesBinding, step: 1, accent: .red)
            }
            Field(label: "Radial Step / Pass", hint: "\(Self.num(params.stepPct))% of radius") {
                Slider(value: $params.stepPct, in: 0...4, step: 0.1)
                    .tint(Catppuccin.red)
            }
            Field(label: "Phase Between Passes") {
                Segmented(selection: $params.phase,
                          options: [(RosePhase.same, "Same"),
                                    (.halfLobe, "½ Lobe"),
                                    (.spiral, "Spiral")],
                          accent: .red)
                // Spiral range shown only when phase == spiral, as conditional
                // child content inside this Field; no visible label (web
                // aria-label only).
                if params.phase == .spiral {
                    Slider(value: $params.spiralPct, in: 2...50, step: 1)
                        .tint(Catppuccin.red)
                        .accessibilityLabel("Spiral phase percent of lobe")
                }
            }

            // Pattern SVG: viewBox 0 0 340 340, maxWidth 420, centered.
            // Paths: fill none, stroke S.teal, strokeOpacity 0.85, strokeWidth 1.
            DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 340, height: 340),
                          maxWidth: 420) { svg in
                for pts in paths {
                    guard let first = pts.first else { continue }
                    var p = Path()
                    p.move(to: first)
                    for pt in pts.dropFirst() { p.addLine(to: pt) }
                    p.closeSubpath()
                    svg.path(p, stroke: Catppuccin.teal.opacity(0.85), width: 1)
                }
            }
            .frame(maxWidth: .infinity)

            // Readouts (§8b formulas; accents ½-Lobe=S.red, Repeats=S.teal, Cuts=S.green).
            let clampedPasses = max(1, min(48, params.passes))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                Readout(label: "½-Lobe Phase Shift",
                        value: String(format: "%.1f", RosePattern.phaseShiftDeg(params)),
                        unit: "°",
                        sub: "rosette rotation on the phasing wheel",
                        accent: .red)
                Readout(label: "Pattern Repeats",
                        value: "\(RosePattern.patternRepeats(params))",
                        unit: "around",
                        sub: "one per rosette lobe",
                        accent: .teal)
                Readout(label: "Cuts Drawn",
                        value: "\(paths.count)",
                        unit: "",
                        sub: paths.count < clampedPasses
                            ? "band reached center — extra passes dropped"
                            : "full band",
                        accent: .green)
            }

            // §8c Pattern Lab note (verbatim; web bold markers dropped —
            // NoteView renders plain text, same as prior sections).
            NoteView(tone: .info, text: "These are cut centerlines — the real cut has the width and shape of your cutter, and amplitude at the work depends on rosette throw and where the rubber rides, so treat the slider as proportion, not inches. The math is the rocking (face) motion; pumping does the identical thing axially on a dome or box lid. The Phased spikes preset is the No. 2195 trick from the Plumier videos: cut the pattern, phase the rosette half a lobe, cut again — the crossings make the spikes.")
        }
    }

    // MARK: - Resources (§8c)

    /// Descriptions verbatim from §8c resources table (view-local; RoseData
    /// carries name + URL only). Index-aligned with RoseData.resources;
    /// last entry (Society of Ornamental Turners) has no description in source.
    private static let resourceDescriptions: [String] = [
        "workshop, classes, and the Holtzapffel lathe videos",
        "the Holtzapffel record",
        "machines & makers",
        "including building your own",
        "modern rose engines",
        "Bill Ooms: rosette math and a 3-D rose-engine surface simulator, the serious prior art for the pattern lab above",
        "",
    ]

    /// Links with color S.teal inside a Note component (§8c).
    private var resourcesContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(RoseData.resources.indices, id: \.self) { i in
                let res = RoseData.resources[i]
                let desc = Self.resourceDescriptions[i]
                (linkText(res) + Text(verbatim: desc.isEmpty ? "" : " — \(desc)"))
                    .font(AppFont.body(13))
                    .foregroundStyle(Catppuccin.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
        .background(Catppuccin.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Catppuccin.blue.opacity(0.4)))
        // Markdown links take their color from tint, not foregroundStyle;
        // web renders these <a> with color S.teal (§8c).
        .tint(Catppuccin.teal)
    }

    private func linkText(_ res: (name: String, url: String)) -> Text {
        if let url = URL(string: res.url) {
            return Text(.init("[\(res.name)](\(url.absoluteString))"))
                .foregroundStyle(Catppuccin.teal)
                .underline()
        }
        return Text(verbatim: res.name).foregroundStyle(Catppuccin.teal)
    }

    // MARK: - Helpers

    /// Int-backed bindings for NumberInput (Binding<Double>), clamped to the
    /// web's ranges (lobes 1–60, passes 1–48; RosePattern clamps again).
    private var lobesBinding: Binding<Double> {
        Binding(get: { Double(params.lobes) },
                set: { params.lobes = max(1, min(60, Int($0.rounded()))) })
    }

    private var passesBinding: Binding<Double> {
        Binding(get: { Double(params.passes) },
                set: { params.passes = max(1, min(48, Int($0.rounded()))) })
    }

    /// JS-style number rendering for hints: 0 → "0", 1.2 → "1.2".
    private static func num(_ v: Double) -> String {
        v == v.rounded() ? String(Int(v)) : String(format: "%.1f", v)
    }

    /// Collapse — DisclosureGroup with Panel chrome (web Collapse, accent S.red).
    private func collapse<C: View>(_ title: String, expanded: Binding<Bool>,
                                   @ViewBuilder content: () -> C) -> some View {
        let body = VStack(alignment: .leading, spacing: 12) { content() }
        return DisclosureGroup(isExpanded: expanded) {
            body.padding(.top, 12)
        } label: {
            Text(title)
                .font(AppFont.display(18))
                .foregroundStyle(Catppuccin.red)
                .multilineTextAlignment(.leading)
        }
        .tint(Catppuccin.red)
        .padding(16)
        .background(Catppuccin.mantle, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Catppuccin.red.opacity(0.25)))
    }

    /// Renders `**bold**` spans as semibold `Catppuccin.text` (web <strong>)
    /// and `*italic*` spans italic (web <em>), within body prose.
    private static func rich(_ s: String) -> Text {
        var out = Text(verbatim: "")
        let boldParts = s.components(separatedBy: "**")
        for (i, part) in boldParts.enumerated() {
            if i % 2 == 1 {
                out = out + Text(verbatim: part)
                    .fontWeight(.semibold)
                    .foregroundStyle(Catppuccin.text)
            } else {
                let italicParts = part.components(separatedBy: "*")
                for (j, ip) in italicParts.enumerated() {
                    let t = Text(verbatim: ip)
                    out = out + (j % 2 == 1 ? t.italic() : t)
                }
            }
        }
        return out
    }
}

#Preview {
    NavigationStack { RoseEngineView().navigationTitle("Rose Engine") }
}
