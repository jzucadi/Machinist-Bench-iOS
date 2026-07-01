import SwiftUI

struct TaperSubView: View {
    let system: UnitSystem

    // Stored in inches
    @State private var largeDia: Double = 1.0
    @State private var smallDia: Double = 0.75
    @State private var taperLength: Double = 3.0
    @State private var betweenCenters: Double = 0.0

    private var result: TaperResult? {
        taper(
            largeDiaIn: largeDia,
            smallDiaIn: smallDia,
            lengthIn: taperLength,
            betweenCentersIn: betweenCenters
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Large Diameter", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($largeDia, system: system),
                                step: system == .metric ? 1 : 0.125,
                                accent: .mauve)
                }
                Field(label: "Small Diameter", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($smallDia, system: system),
                                step: system == .metric ? 1 : 0.125,
                                accent: .mauve)
                }
                Field(label: "Length of Taper", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($taperLength, system: system),
                                step: system == .metric ? 1 : 0.125,
                                accent: .mauve)
                }
                Field(label: "Between Centers", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($betweenCenters, system: system),
                                step: system == .metric ? 1 : 0.125,
                                accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            if let r = result {
                Panel(title: "Results", accent: .mauve) {
                    Readout(label: "Included Angle",
                            value: String(format: "%.3f", r.includedAngleDeg),
                            unit: "°",
                            sub: String(format: "Half angle: %.3f°", r.halfAngleDeg),
                            accent: .mauve)
                    Readout(label: "Taper / Foot",
                            value: String(format: "%.4f", r.tpf),
                            unit: "in/ft",
                            sub: String(format: "Taper/inch: %.4f", r.tpi),
                            accent: .mauve)
                    Readout(label: "Set-over (full length)",
                            value: formatLength(r.setover),
                            unit: system == .metric ? "mm" : "in",
                            accent: .mauve)
                    if let sbc = r.setoverBetweenCenters {
                        Readout(label: "Set-over (this part)",
                                value: formatLength(sbc),
                                unit: system == .metric ? "mm" : "in",
                                accent: .mauve)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
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
        TaperSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
