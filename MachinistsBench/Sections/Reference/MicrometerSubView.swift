import SwiftUI

/// Reference → Micrometer (M7 B5).
/// Interactive slider-driven micrometer reading diagram (§4.2) with live
/// decomposition readouts, plus three static instrument diagrams
/// (§4.3 vernier mic, §4.4 vernier caliper, §4.5 inside mic) and the
/// §4.6 prose panels. Reading math lives in Core (`MicReading.decompose`).
struct MicrometerSubView: View {
    let system: UnitSystem

    /// Web: `useState(0.276)` — §4 golden value, shown on first open.
    @State private var val: Double = 0.276

    // MARK: - §0/B1 color bindings (S.* → Catppuccin)

    private static let blue   = Catppuccin.blue      // S.blue
    private static let teal   = Catppuccin.teal      // S.teal
    private static let green  = Catppuccin.green     // S.green
    private static let amber  = Catppuccin.peach     // S.amber (addendum ruling)
    private static let orange = Catppuccin.peach     // S.orange (addendum ruling)
    private static let violet = Catppuccin.mauve     // S.violet
    private static let mut    = Catppuccin.overlay1  // S.mut
    private static let mut2   = Catppuccin.overlay0  // S.mut2
    private static let panel2 = Catppuccin.surface0  // S.panel2 (inside SVGs)
    private static let line2  = Catppuccin.surface1  // S.line / S.line2 (inside SVGs)

    // MARK: - Body (web panel order: reading → how-to → vernier → caliper → inside → habits)

    var body: some View {
        VStack(spacing: 16) {
            readingPanel
                .padding(.horizontal, 16)
            howToPanel
                .padding(.horizontal, 16)
            vernierPanel
                .padding(.horizontal, 16)
            caliperPanel
                .padding(.horizontal, 16)
            insideMicPanel
                .padding(.horizontal, 16)
            habitsPanel
                .padding(.horizontal, 16)
        }
    }

    // MARK: - Panel 1 — Reading an Analog Micrometer (interactive, accent S.teal)

    private var readingPanel: some View {
        // Value-dependent decomposition — Core only, never recomputed here.
        let p = MicReading.decompose(val)
        // §4.1: thimble tick index (0–24); equals `thim` for the 0–1″ range.
        let thim = Int((p.thimble * 1000).rounded())
        let hundredsStr = String(format: "%.3f", Double(p.major) * 0.1)
        let minorStr    = String(format: "%.3f", Double(p.minor) * 0.025)
        let thimStr     = String(format: "%.3f", p.thimble)
        let totalStr    = String(format: "%.3f", p.total)

        return Panel(title: "Reading an Analog Micrometer", accent: .teal,
                     subtitle: "0–1 inch · graduations of 0.001″") {
            Self.rich("A micrometer reads in three layers that you simply add together. The **sleeve** (the fixed barrel) carries the big numbers — each is **0.100″** — and between them are ticks every **0.025″**. The rotating **thimble** is divided into 25 parts, each **0.001″**. Drag the slider to spin the thimble and watch the reading build up.")
                .font(AppFont.body(13))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(maxWidth: .infinity, alignment: .leading)

            diagramInset {
                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 420, height: 170)) { svg in
                    Self.drawInteractiveMic(svg, p)
                }
            }

            // Web: <input type=range min=0 max=0.999 step=0.001> + "Random reading" button
            HStack(spacing: 12) {
                Slider(value: $val, in: 0...0.999, step: 0.001)
                    .tint(Self.teal)
                Button("Random reading") {
                    val = Double(Int.random(in: 0...999)) / 1000
                }
                .font(AppFont.display(12))
                .foregroundStyle(Self.teal)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(Self.teal.opacity(0.11), in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Self.teal))
            }

            // Live decomposition readouts (web Grid min=120)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                Readout(label: "Sleeve · 0.100s", value: hundredsStr, unit: "in",
                        accent: .blue)
                Readout(label: "Sleeve · 0.025s", value: minorStr, unit: "in",
                        sub: "\(p.minor) tick\(p.minor == 1 ? "" : "s")", accent: .peach)
                Readout(label: "Thimble · 0.001s", value: thimStr, unit: "in",
                        sub: "line \(thim)", accent: .green)
                Readout(label: "Total Reading", value: totalStr, unit: "in",
                        sub: String(format: "%.3f mm", p.total * 25.4), accent: .teal,
                        big: true)
            }

            // Equation strip: hundreds + minor + thimble = total (web colors)
            (Text(hundredsStr).foregroundStyle(Self.blue)
             + Text(" + ")
             + Text(minorStr).foregroundStyle(Self.amber)
             + Text(" + ")
             + Text(thimStr).foregroundStyle(Self.green)
             + Text(" = ")
             + Text(totalStr + "″").fontWeight(.bold).foregroundStyle(Self.teal))
                .font(AppFont.mono(13))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Self.panel2, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Self.line2))
        }
    }

    // MARK: - Panel 2 — How to Read It — Step by Step (accent S.blue)

    private var howToPanel: some View {
        Panel(title: "How to Read It — Step by Step", accent: .blue) {
            listItem(number: "1.", "**Read the largest sleeve number showing** to the left of the thimble — each numbered mark is 0.100″ (so \"2\" = 0.200″).")
            listItem(number: "2.", "**Count the extra 0.025″ ticks** between that number and the thimble edge — each adds 0.025″ (one tick 0.025, two 0.050, three 0.075).")
            listItem(number: "3.", "**Read the thimble line** that lines up with the long datum line on the sleeve — each division is 0.001″.")
            listItem(number: "4.", "**Add the three.** Sleeve hundreds + sleeve twenty-fifths + thimble thousandths = your measurement.")
            NoteView(tone: .info, text: "Worked example — reading 0.276″: the \"2\" (0.200) is showing, plus three more 0.025 ticks (0.075), and the thimble reads 1 (0.001). 0.200 + 0.075 + 0.001 = 0.276″.")
        }
    }

    // MARK: - Panel 3 — Ten-Thousandths — the Micrometer Vernier (accent S.violet)

    private var vernierPanel: some View {
        Panel(title: "Ten-Thousandths — the Micrometer Vernier", accent: .mauve,
              subtitle: "reading to 0.0001″ with the sleeve vernier scale") {
            Self.rich("A **vernier micrometer** adds a short scale of 10 lines running *along* the sleeve, numbered 0–9. Those 10 lines are spaced to span 9 thimble divisions, so each is 0.0001″ finer than a thimble line. Take the ordinary reading first, then find the one sleeve-vernier line that lines up *exactly* with any thimble line — its number is the count of ten-thousandths to add.")
                .font(AppFont.body(13))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(maxWidth: .infinity, alignment: .leading)

            diagramInset {
                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 420, height: 200)) { svg in
                    Self.drawVernierMic(svg)
                }
            }

            NoteView(tone: .info, text: "Worked example: an ordinary reading of 0.276″ where the vernier's 3 lines up exactly becomes 0.2763″. Only one vernier line ever coincides at a time — that's the one you read. The metric vernier micrometer works the same way, reading the sleeve in 0.5 mm and the thimble in 0.01 mm, with the vernier adding 0.001 mm.")
        }
    }

    // MARK: - Panel 4 — Reading a Vernier Caliper (accent S.green)

    private var caliperPanel: some View {
        Panel(title: "Reading a Vernier Caliper", accent: .green,
              subtitle: "main scale + sliding vernier · to 0.001″ (0.02 mm)") {
            Self.rich("A vernier caliper has a fixed **main scale** and a sliding **vernier scale**. On an inch caliper the main scale is divided into 0.025″ steps; the vernier has 25 divisions that span 24 of them, making each vernier division 0.001″ finer. Read the main scale at the vernier's **0** mark, then find the one vernier line that lines up with any main-scale line and add that many thousandths.")
                .font(AppFont.body(13))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(maxWidth: .infinity, alignment: .leading)

            diagramInset {
                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 460, height: 180)) { svg in
                    Self.drawVernierCaliper(svg)
                }
            }

            // Result strip: main 0.400 + vernier 0.013 = 0.413″
            (Text("main ")
             + Text("0.400").foregroundStyle(Self.blue)
             + Text(" + vernier ")
             + Text("0.013").foregroundStyle(Self.green)
             + Text(" = ")
             + Text("0.413″").fontWeight(.bold).foregroundStyle(Self.teal))
                .font(AppFont.mono(13))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Self.panel2, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Self.line2))

            NoteView(tone: .info, text: "Steps: (1) read the main scale at the vernier 0 — here just past 0.400″; (2) scan the vernier for the single line that aligns with a main line — the 13th; (3) add 13 × 0.001 = 0.013. Total 0.413″. A metric vernier caliper reads the main scale in 1 mm and the 50-division vernier adds 0.02 mm per line.")
        }
    }

    // MARK: - Panel 5 — Using an Inside (Internal) Micrometer (accent S.orange → peach)

    private var insideMicPanel: some View {
        Panel(title: "Using an Inside (Internal) Micrometer", accent: .peach,
              subtitle: "bore & groove diameters · rock to the true reading") {
            Self.rich("An inside micrometer measures bores, grooves, and slots from the inside out. The sleeve and thimble are read exactly like an outside mic — the difference is all in technique and in the **extension rods**. A small head covers a short range (often about 0.5″ of travel); to reach a larger bore you thread on a rod or spacer, and the bore size is the **head reading plus the rod's nominal length**. Tubular inside mics and three-point bore gauges work on the same idea.")
                .font(AppFont.body(13))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(maxWidth: .infinity, alignment: .leading)

            diagramInset {
                DiagramCanvas(viewBox: CGRect(x: 0, y: 0, width: 440, height: 200)) { svg in
                    Self.drawInsideMic(svg)
                }
            }

            Text("TECHNIQUE")
                .font(AppFont.display(12))
                .kerning(1.2)
                .foregroundStyle(Self.orange)

            listItem(number: "1.", "**Pick the right rod.** Choose the extension rod that puts the bore size within the head's range, thread it on firmly (a loose rod ruins the reading), and set it against its shoulder.")
            listItem(number: "2.", "**Find the true diameter, not a chord.** Hold one contact against the wall and gently *rock* the mic through the bore: sweep it across the diameter to find the **largest** reading, and tilt it along the axis to find the **smallest**. The true diameter is the maximum across × minimum along — the point where it just drags.")
            listItem(number: "3.", "**Use a light, repeatable feel.** Inside mics have no ratchet, so feel is everything — expand until you feel a slight, even drag at the turning point, no more. Take the reading two or three times.")
            listItem(number: "4.", "**Read like an outside mic, then add the rod.** Read sleeve + thimble (+ vernier) as usual, then add the rod's nominal length. A head reading of 0.150″ on a 1.000″ rod = a 1.150″ bore.")
            listItem(number: "5.", "**Verify the setup.** Check the assembled mic against a ring gauge or a known bore, or set it with gauge blocks in a holder, before trusting a critical measurement.")

            NoteView(tone: .warn, text: "The two errors that bite: reading across a chord instead of the true diameter (always too small — rock to the high point), and heat from your hand growing the rods on long setups. For deep or precise bores many shops prefer a dial bore gauge, which is zeroed to a master and naturally self-centers.")
        }
    }

    // MARK: - Panel 6 — Good Measuring Habits (accent S.amber → peach)

    private var habitsPanel: some View {
        Panel(title: "Good Measuring Habits", accent: .peach) {
            listItem(number: "•", "**Use the ratchet or friction thimble** for the last turn — consistent feel means consistent pressure and repeatable readings.")
            listItem(number: "•", "**Wipe the anvil and spindle** and the part; a chip easily adds a thou or more.")
            listItem(number: "•", "**Check zero** with the faces closed (or on the standard for larger mics) and note any error.")
            listItem(number: "•", "**Mind temperature** — heat from your hand expands both part and tool; let precision work normalize.")
            listItem(number: "•", "**Hold square to the work** and measure across the true diameter, rocking slightly to find the high point.")
        }
    }

    // MARK: - Prose helpers

    /// Web inset wrapper around each SVG: background S.inset (→ mantle),
    /// borderRadius 12, 1px S.line2 (→ surface1) border.
    private func diagramInset<C: View>(@ViewBuilder _ content: () -> C) -> some View {
        content()
            .padding(10)
            .background(Catppuccin.mantle, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Catppuccin.surface1, lineWidth: 1))
    }

    /// Ordered/bulleted list row (web <ol>/<ul> li with <strong> lead).
    private func listItem(number: String, _ s: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(number)
                .font(AppFont.mono(13))
                .foregroundStyle(Catppuccin.overlay1)
            Self.rich(s)
                .font(AppFont.body(13))
                .foregroundStyle(Catppuccin.subtext0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// Renders `**bold**` spans as semibold `Catppuccin.text` (web <strong>
    /// color S.ink) and `*italic*` spans italic (web <em>), within body prose.
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

    // MARK: - §4.2 SVG 1 — Interactive Micrometer (viewBox 0 0 420 170)

    private static func drawInteractiveMic(_ svg: SVGContext, _ p: MicParts) {
        let frameY: CGFloat = 70, axis: CGFloat = 92
        let sleeveX0: CGFloat = 150, sleeveX1: CGFloat = 360
        let sleeveLen = sleeveX1 - sleeveX0          // 210
        let pxPerInch = sleeveLen / 1                // 210 px per inch
        // Value-dependent geometry: consumes MicParts only.
        let snap = p.total
        let thimbleEdge = sleeveX0 + snap * pxPerInch
        // §4.1 thimIdx (0–24); equals the thimble thousandths for the 0–1″ range.
        let thimIdx = Int((p.thimble * 1000).rounded())

        // 1 — anvil
        svg.roundedRect(CGRect(x: 20, y: axis - 9, width: 40, height: 18),
                        cornerRadius: 3, fill: panel2, stroke: line2, width: 1.5)
        // 2 — barrel
        svg.roundedRect(CGRect(x: 60, y: axis - 5, width: 90, height: 10),
                        cornerRadius: 2, fill: line2)
        // 3 — sleeve body
        svg.roundedRect(CGRect(x: sleeveX0, y: axis - 26, width: sleeveLen, height: 52),
                        cornerRadius: 5, fill: panel2, stroke: line2, width: 1.5)
        // 4 — datum line
        svg.line(sleeveX0, axis, sleeveX1 + 30, axis, stroke: amber, width: 1.4)
        // 5 — sleeve ticks (n=0..40; hundred marks every 4th, labels 0..10)
        for n in 0...40 {
            let x = sleeveX0 + CGFloat(n) * 0.025 * pxPerInch
            let isHundred = n % 4 == 0
            svg.line(x, axis, x, axis + (isHundred ? 14 : 8),
                     stroke: isHundred ? blue : mut2, width: isHundred ? 1.6 : 1)
            if isHundred {
                svg.text("\(n / 4)", x: x, y: axis + 26, size: 9,
                         color: blue, mono: true, anchor: .middle, weight: .bold)
            }
        }
        // 6a — thimble body
        svg.roundedRect(CGRect(x: thimbleEdge, y: frameY - 6,
                               width: sleeveX1 + 34 - thimbleEdge, height: 64),
                        cornerRadius: 6, fill: teal.opacity(0.11),
                        stroke: teal, width: 1.8)
        // 6b — thimble edge
        svg.line(thimbleEdge, frameY - 6, thimbleEdge, frameY + 58,
                 stroke: teal, width: 2.4)
        // 6c — thimble divisions (k=-3..3 around thimIdx; long tick when idx%5==0)
        for k in -3...3 {
            let idx = ((thimIdx + k) % 25 + 25) % 25
            let y = axis - CGFloat(k) * 9
            let longTick = idx % 5 == 0
            svg.line(thimbleEdge + 4, y, thimbleEdge + (longTick ? 18 : 12), y,
                     stroke: k == 0 ? green : teal, width: k == 0 ? 2.2 : 1.2)
            if longTick {
                svg.text("\(idx)", x: thimbleEdge + 24, y: y + 3, size: 8.5,
                         color: teal, mono: true, anchor: .start, weight: .bold)
            }
        }
        // 7–8 — scale labels (F.body)
        svg.text("SLEEVE", x: sleeveX0, y: axis - 32, size: 8.5,
                 color: mut, mono: false, anchor: .start)
        svg.text("THIMBLE", x: sleeveX1 + 10, y: frameY - 12, size: 8.5,
                 color: mut, mono: false, anchor: .end)
    }

    // MARK: - §4.3 SVG 2 — Vernier Micrometer (viewBox 0 0 420 200, static)

    private static func drawVernierMic(_ svg: SVGContext) {
        let matchLine = 3
        let baseY: CGFloat = 30, thStep: CGFloat = 15
        let verStep = thStep * 9 / 10        // 13.5

        // 1–2 — datum line + label
        svg.line(60, baseY - 12, 60, baseY + 10 * thStep + 12, stroke: amber, width: 1.4)
        svg.text("datum", x: 48, y: baseY - 16, size: 8.5,
                 color: amber, mono: false, anchor: .middle)
        // 3 — thimble lines (i=0..10; long every 5th; match at 3)
        for i in 0...10 {
            let y = baseY + CGFloat(i) * thStep
            let lng = i % 5 == 0
            svg.line(60, y, 60 + (lng ? 40 : 28), y,
                     stroke: i == matchLine ? green : teal,
                     width: i == matchLine ? 2.4 : 1.3)
            if lng {
                svg.text(String(format: "%02d", i), x: 60 + 48, y: y + 3, size: 9,
                         color: teal, mono: true, anchor: .start)
            }
        }
        // 4 — thimble header
        svg.text("THIMBLE · 0.001″", x: 60 + 40, y: baseY - 16, size: 8.5,
                 color: teal, mono: false, anchor: .start)
        // 5 — vernier lines (i=0..9, all labeled; match at 3)
        for i in 0...9 {
            let y = baseY + CGFloat(i) * verStep
            let isMatch = i == matchLine
            svg.line(60 - (isMatch ? 40 : 28), y, 60, y,
                     stroke: isMatch ? green : violet, width: isMatch ? 2.4 : 1.3)
            svg.text("\(i)", x: 60 - 46, y: y + 3, size: 9,
                     color: isMatch ? green : violet, mono: true, anchor: .end,
                     weight: isMatch ? .bold : .regular)
        }
        // 6 — vernier header
        svg.text("VERNIER · 0.0001″", x: 60 - 40, y: baseY - 16, size: 8.5,
                 color: violet, mono: false, anchor: .end)
        // 7–8 — coincide callouts
        svg.text("← lines coincide at 3", x: 220,
                 y: baseY + CGFloat(matchLine) * thStep + 4, size: 10,
                 color: green, mono: true, anchor: .start, weight: .bold)
        svg.text("→ add 0.0003″", x: 220,
                 y: baseY + CGFloat(matchLine) * thStep + 20, size: 9,
                 color: mut2, mono: false, anchor: .start)
    }

    // MARK: - §4.4 SVG 3 — Vernier Caliper (viewBox 0 0 460 180, static)

    private static func drawVernierCaliper(_ svg: SVGContext) {
        let mainStep: CGFloat = 26
        let x0: CGFloat = 30, mainY: CGFloat = 58
        let winStart = 0.375
        let vern0X = x0 + 1 * mainStep       // 56
        let matchK = 13
        let vStep = mainStep * 24 / 25       // 24.96

        // 1 — main bar
        svg.roundedRect(CGRect(x: x0 - 10, y: mainY - 34,
                               width: 8 * mainStep + 30, height: 20),
                        cornerRadius: 3, fill: panel2, stroke: line2, width: 1.2)
        // 2 — main ticks (k=0..8, val=0.375+k*0.025; big when val is a 0.1 multiple)
        for k in 0...8 {
            let v = winStart + Double(k) * 0.025
            let x = x0 + CGFloat(k) * mainStep
            let big = abs(v / 0.1 - (v / 0.1).rounded()) < 1e-9
            svg.line(x, mainY - 34, x, mainY - 34 + (big ? 20 : 13),
                     stroke: big ? blue : mut2, width: big ? 1.6 : 1)
            if big {
                svg.text(String(format: "%.1f", v), x: x, y: mainY - 40, size: 9,
                         color: blue, mono: true, anchor: .middle, weight: .bold)
            }
        }
        // 3 — main header
        svg.text("MAIN · 0.025″", x: x0 - 6, y: mainY - 46, size: 8.5,
                 color: blue, mono: false, anchor: .start)
        // 4 — vernier box
        svg.roundedRect(CGRect(x: vern0X - 8, y: mainY + 6,
                               width: 6.5 * vStep + 22, height: 22),
                        cornerRadius: 3, fill: green.opacity(0.08),
                        stroke: green, width: 1.4)
        // 5 — vernier ticks (k=0..16; long every 5th; match at 13, unlabeled)
        for k in 0...16 {
            let x = vern0X + CGFloat(k) * vStep
            let lng = k % 5 == 0
            let isMatch = k == matchK
            svg.line(x, mainY + 6, x, mainY + 6 - (isMatch ? 22 : (lng ? 14 : 9)),
                     stroke: isMatch ? green : teal, width: isMatch ? 2.4 : 1.1)
            if lng {
                svg.text("\(k)", x: x, y: mainY + 40, size: 8.5,
                         color: isMatch ? green : teal, mono: true, anchor: .middle,
                         weight: isMatch ? .bold : .regular)
            }
        }
        // 6 — vernier header
        svg.text("VERNIER · +0.001″ each", x: vern0X - 6, y: mainY + 52, size: 8.5,
                 color: green, mono: false, anchor: .start)
        // 7–8 — vernier zero marker + label
        svg.line(vern0X, mainY - 14, vern0X, mainY + 30,
                 stroke: amber, width: 1.4, dash: [3, 2])
        svg.text("0", x: vern0X, y: mainY - 2, size: 9,
                 color: amber, mono: true, anchor: .middle, weight: .bold)
        // 9 — match callout
        svg.text("lines up → +0.013″", x: vern0X + CGFloat(matchK) * vStep,
                 y: mainY + 62, size: 9, color: green, mono: false, anchor: .middle,
                 weight: .bold)
    }

    // MARK: - §4.5 SVG 4 — Inside Micrometer (viewBox 0 0 440 200, static)

    private static func drawInsideMic(_ svg: SVGContext) {
        let cx: CGFloat = 220, cy: CGFloat = 100
        let rO: CGFloat = 80, rI: CGFloat = 66

        // 1–2 — bore outer wall + bore inner
        svg.circle(cx: cx, cy: cy, r: rO, stroke: line2, width: 10)
        svg.circle(cx: cx, cy: cy, r: rI, fill: panel2, stroke: mut, width: 1)
        // 3 — bore label
        svg.text("BORE WALL", x: cx, y: cy - rO - 6, size: 9,
                 color: mut, mono: false, anchor: .middle)
        // 4–5 — contact points
        svg.circle(cx: cx - rI, cy: cy, r: 4, fill: orange)
        svg.circle(cx: cx + rI, cy: cy, r: 4, fill: orange)
        // 6–7 — extension rod + label (S.amber+"33" → 0.20)
        svg.roundedRect(CGRect(x: cx - rI, y: cy - 5, width: rI * 0.7, height: 10),
                        cornerRadius: 2, fill: amber.opacity(0.20),
                        stroke: amber, width: 1.3)
        svg.text("extension rod", x: cx - rI * 0.65, y: cy - 10, size: 8.5,
                 color: amber, mono: false, anchor: .middle)
        // 8–9 — mic head (S.orange+"22" → 0.13) + thimble (S.teal+"1c" → 0.11)
        svg.roundedRect(CGRect(x: cx - rI * 0.3, y: cy - 7, width: rI * 1, height: 14),
                        cornerRadius: 3, fill: orange.opacity(0.13),
                        stroke: orange, width: 1.5)
        svg.roundedRect(CGRect(x: cx + rI * 0.35, y: cy - 7, width: rI * 0.55, height: 14),
                        cornerRadius: 3, fill: teal.opacity(0.11),
                        stroke: teal, width: 1.4)
        // 10 — head label
        svg.text("mic head + thimble", x: cx, y: cy + 22, size: 8.5,
                 color: orange, mono: false, anchor: .middle)
        // 11 — diameter reference
        svg.line(cx - rI, cy, cx + rI, cy, stroke: mut, width: 0.8, dash: [3, 3])
        // 12 — rock arc (A 22 22 0 0 1)
        let arc = svgArcPath(from: CGPoint(x: cx + rI - 2, y: cy - 20),
                             to: CGPoint(x: cx + rI - 2, y: cy + 20),
                             r: 22, largeArc: false, sweep: true)
        svg.path(arc, stroke: green, width: 1.6)
        // 13–14 — arrowheads
        svg.poly([CGPoint(x: cx + rI - 2, y: cy - 20),
                  CGPoint(x: cx + rI - 7, y: cy - 15),
                  CGPoint(x: cx + rI + 3, y: cy - 14)], fill: green)
        svg.poly([CGPoint(x: cx + rI - 2, y: cy + 20),
                  CGPoint(x: cx + rI - 7, y: cy + 15),
                  CGPoint(x: cx + rI + 3, y: cy + 14)], fill: green)
        // 15 — rock & sweep label
        svg.text("rock & sweep", x: cx + rI + 14, y: cy + 4, size: 8.5,
                 color: green, mono: false, anchor: .start)
    }
}

#Preview {
    ScrollView {
        MicrometerSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
