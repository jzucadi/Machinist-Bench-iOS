import SwiftUI

struct PolygonSubView: View {
    let system: UnitSystem

    @State private var sidesDouble: Double = 6
    @State private var modeTag: String = "af"
    @State private var value: Double = 1.5  // stored in inches

    private var sides: Int { max(3, Int(sidesDouble.rounded())) }

    private var polyMode: PolyMode {
        switch modeTag {
        case "ac":   return .ac
        case "side": return .side
        default:     return .af
        }
    }

    private var dims: PolygonDims {
        // `value` is stored in inches (metricLengthBinding handles the display conversion)
        polygon(sides: sides, mode: polyMode, value: value)
    }

    private var interiorAngle: Double {
        Double(sides - 2) * 180.0 / Double(sides)
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Sides (N)") {
                    NumberInput(value: $sidesDouble, step: 1, accent: .mauve)
                }
                Field(label: "Mode") {
                    Segmented(selection: $modeTag,
                              options: [("af", "Across Flats"), ("ac", "Across Corners"), ("side", "Side")],
                              accent: .mauve)
                }
                Field(label: modeLabel, hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($value, system: system),
                                step: system == .metric ? 1 : 0.125,
                                accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Across Corners",
                        value: formatLength(dims.acrossCorners),
                        unit: system == .metric ? "mm" : "in",
                        accent: .mauve)
                Readout(label: "Across Flats",
                        value: formatLength(dims.acrossFlats),
                        unit: system == .metric ? "mm" : "in",
                        accent: .mauve)
                Readout(label: "Side",
                        value: formatLength(dims.side),
                        unit: system == .metric ? "mm" : "in",
                        accent: .mauve)
                Readout(label: "Apothem",
                        value: formatLength(dims.apothem),
                        unit: system == .metric ? "mm" : "in",
                        accent: .mauve)
                Readout(label: "Area",
                        value: formatArea(dims.area),
                        unit: system == .metric ? "mm²" : "in²",
                        sub: "Perimeter: \(formatLength(dims.perimeter)) \(system == .metric ? "mm" : "in")",
                        accent: .mauve)
                Readout(label: "Sides",
                        value: "\(sides)",
                        unit: "",
                        sub: String(format: "Interior angle %.2f°", interiorAngle),
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Helpers

    private var modeLabel: String {
        switch modeTag {
        case "ac":   return "Across Corners"
        case "side": return "Side Length"
        default:     return "Across Flats"
        }
    }

    private func formatLength(_ valueIn: Double) -> String {
        if system == .metric {
            return String(format: "%.3f", valueIn * 25.4)
        } else {
            return String(format: "%.4f", valueIn)
        }
    }

    private func formatArea(_ areaIn2: Double) -> String {
        if system == .metric {
            return String(format: "%.3f", areaIn2 * 645.16)
        } else {
            return String(format: "%.4f", areaIn2)
        }
    }
}

#Preview {
    ScrollView {
        PolygonSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
