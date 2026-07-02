import SwiftUI

struct KnurlSubView: View {
    let system: UnitSystem

    @State private var dia: Double = 0.5        // stored in inches
    @State private var pitchType: String = "TPI"
    @State private var pitchValue: Double = 96

    private var pitchIn: Double {
        pitchType == "TPI" ? 1.0 / pitchValue : pitchValue / 25.4
    }

    private var result: KnurlResult {
        knurl(diaIn: dia, pitchIn: pitchIn)
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Blank Diameter", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($dia, system: system),
                                step: system == .metric ? 0.1 : 0.005,
                                accent: .mauve)
                }
                Field(label: "Pitch Type") {
                    Segmented(selection: $pitchType,
                              options: [("TPI", "TPI"), ("mm", "mm pitch")],
                              accent: .mauve)
                }
                Field(label: "Pitch Value", hint: pitchType == "TPI" ? "TPI" : "mm") {
                    NumberInput(value: $pitchValue,
                                step: pitchType == "TPI" ? 4 : 0.1,
                                accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Tracking Diameter",
                        value: formatLength(result.idealDiaIn),
                        unit: system == .metric ? "mm" : "in",
                        accent: .mauve)
                Readout(label: "Teeth Around",
                        value: "\(result.teeth)",
                        unit: "",
                        accent: .mauve)
                Readout(label: adjustLabel,
                        value: formatLength(abs(result.adjustIn)),
                        unit: system == .metric ? "mm" : "in",
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Helpers

    private var adjustLabel: String {
        result.adjustIn > 0 ? "Reduce From Target" : "Increase From Target"
    }

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
        KnurlSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
