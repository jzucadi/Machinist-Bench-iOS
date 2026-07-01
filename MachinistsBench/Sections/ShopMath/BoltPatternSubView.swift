import SwiftUI

struct BoltPatternSubView: View {
    let system: UnitSystem

    // Mode
    @State private var mode = "circle"

    // Circle inputs (stored in inches)
    @State private var circleCount: Double = 6
    @State private var bcd: Double = 3.0          // inches
    @State private var centerX: Double = 0.0      // inches
    @State private var centerY: Double = 0.0      // inches
    @State private var startDeg: Double = 0.0

    // Line inputs (stored in inches)
    @State private var lineCount: Double = 4
    @State private var pitch: Double = 3.0        // inches
    @State private var lineAngle: Double = 0.0
    @State private var x0: Double = 0.0           // inches
    @State private var y0: Double = 0.0           // inches

    var body: some View {
        VStack(spacing: 16) {
            // Mode picker
            Field(label: "Pattern") {
                Segmented(selection: $mode,
                          options: [("circle", "Circle"), ("line", "Line")],
                          accent: .mauve)
            }
            .padding(.horizontal, 16)

            if mode == "circle" {
                circleSection
            } else {
                lineSection
            }
        }
    }

    // MARK: - Circle

    private var circleCount_int: Int { max(1, Int(circleCount.rounded())) }

    private var circleHoles: [Hole] {
        boltCircle(count: circleCount_int, bcdIn: bcd, centerX: centerX, centerY: centerY, startDeg: startDeg)
    }

    private var chord: Double {
        boltCircleChord(count: circleCount_int, bcdIn: bcd)
    }

    private var circleRows: [[String]] {
        circleHoles.map { h in
            ["\(h.n + 1)", formatLength(h.x), formatLength(h.y), String(format: "%.2f°", h.angle)]
        }
    }

    @ViewBuilder private var circleSection: some View {
        Panel(title: "Inputs", accent: .mauve) {
            Field(label: "Holes (N)") {
                NumberInput(value: $circleCount, step: 1, accent: .mauve)
            }
            Field(label: "BCD", hint: system == .metric ? "mm" : "in") {
                NumberInput(value: metricLengthBinding($bcd, system: system),
                            step: system == .metric ? 1 : 0.125, accent: .mauve)
            }
            Field(label: "Center X", hint: system == .metric ? "mm" : "in") {
                NumberInput(value: metricLengthBinding($centerX, system: system),
                            step: system == .metric ? 1 : 0.125, accent: .mauve)
            }
            Field(label: "Center Y", hint: system == .metric ? "mm" : "in") {
                NumberInput(value: metricLengthBinding($centerY, system: system),
                            step: system == .metric ? 1 : 0.125, accent: .mauve)
            }
            Field(label: "Start Angle", hint: "°") {
                NumberInput(value: $startDeg, step: 5, accent: .mauve)
            }
        }
        .padding(.horizontal, 16)

        Panel(title: "Hole Locations", accent: .mauve) {
            DataTable(
                columns: ["#", "X (\(system == .metric ? "mm" : "in"))", "Y (\(system == .metric ? "mm" : "in"))", "Angle"],
                rows: circleRows,
                accent: .mauve
            )
        }
        .padding(.horizontal, 16)

        Panel(title: "Summary", accent: .mauve) {
            Readout(label: "Chord (hole-to-hole)",
                    value: formatLength(chord),
                    unit: system == .metric ? "mm" : "in",
                    accent: .mauve)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Line

    private var lineCount_int: Int { max(1, Int(lineCount.rounded())) }

    private var lineHoles: [Hole] {
        straightLineHoles(count: lineCount_int, pitchIn: pitch, angleDeg: lineAngle, x0: x0, y0: y0)
    }

    private var overallLength: Double {
        Double(max(0, lineCount_int - 1)) * pitch
    }

    private var lineRows: [[String]] {
        lineHoles.map { h in
            ["\(h.n + 1)", formatLength(h.x), formatLength(h.y)]
        }
    }

    @ViewBuilder private var lineSection: some View {
        Panel(title: "Inputs", accent: .mauve) {
            Field(label: "Holes (N)") {
                NumberInput(value: $lineCount, step: 1, accent: .mauve)
            }
            Field(label: "Pitch", hint: system == .metric ? "mm" : "in") {
                NumberInput(value: metricLengthBinding($pitch, system: system),
                            step: system == .metric ? 1 : 0.125, accent: .mauve)
            }
            Field(label: "Angle", hint: "°") {
                NumberInput(value: $lineAngle, step: 5, accent: .mauve)
            }
            Field(label: "Start X", hint: system == .metric ? "mm" : "in") {
                NumberInput(value: metricLengthBinding($x0, system: system),
                            step: system == .metric ? 1 : 0.125, accent: .mauve)
            }
            Field(label: "Start Y", hint: system == .metric ? "mm" : "in") {
                NumberInput(value: metricLengthBinding($y0, system: system),
                            step: system == .metric ? 1 : 0.125, accent: .mauve)
            }
        }
        .padding(.horizontal, 16)

        Panel(title: "Hole Locations", accent: .mauve) {
            DataTable(
                columns: ["#", "X (\(system == .metric ? "mm" : "in"))", "Y (\(system == .metric ? "mm" : "in"))"],
                rows: lineRows,
                accent: .mauve
            )
        }
        .padding(.horizontal, 16)

        Panel(title: "Summary", accent: .mauve) {
            Readout(label: "Overall Length",
                    value: formatLength(overallLength),
                    unit: system == .metric ? "mm" : "in",
                    accent: .mauve)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Helpers

    private func formatLength(_ valueIn: Double) -> String {
        if system == .metric {
            return String(format: "%.3f", valueIn * 25.4)
        } else {
            return String(format: "%.4f", valueIn)
        }
    }
}

#Preview {
    ScrollView {
        BoltPatternSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
