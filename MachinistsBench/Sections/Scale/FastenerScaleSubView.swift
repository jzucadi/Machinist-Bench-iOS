import SwiftUI

struct FastenerScaleSubView: View {
    let system: UnitSystem

    @State private var diaIn: Double = 0.25   // stored in inches
    @State private var n: Double = 8.0

    private var naiveSizeIn: Double {
        guard n > 0 else { return 0 }
        return fastenerNaive(diaIn: diaIn, n: n)
    }

    private var naiveDisplay: String {
        if system == .metric {
            return String(format: "%.3f", naiveSizeIn * 25.4)
        } else {
            return String(format: "%.4f", naiveSizeIn)
        }
    }
    private var naiveUnit: String { system == .metric ? "mm" : "in" }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Fastener Diameter", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($diaIn, system: system),
                                step: system == .metric ? 0.5 : 0.0625,
                                accent: .mauve)
                }
                Field(label: "Scale (1:N)") {
                    NumberInput(value: $n, step: 1, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Naïve Size",
                        value: naiveDisplay,
                        unit: naiveUnit,
                        accent: .mauve)
            }
            .padding(.horizontal, 16)

            NoteView(tone: .warn,
                     text: "Go oversize — scaled threads are fragile; use BA/ME thread series for models.")
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        FastenerScaleSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
