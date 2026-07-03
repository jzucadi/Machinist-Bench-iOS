import SwiftUI

struct ScaleSpeedSubView: View {
    let system: UnitSystem

    @State private var prototypeMph: Double = 60.0
    @State private var n: Double = 32.0
    @State private var wheelDiaIn: Double = 48.0   // full-size wheel diameter, stored in inches

    private var result: (scaleMph: Double, wheelRPM: Double) {
        guard n > 0, wheelDiaIn > 0 else { return (0, 0) }
        return scaleSpeed(prototypeMph: prototypeMph, n: n, wheelDiaIn: wheelDiaIn)
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Prototype Speed", hint: "mph") {
                    NumberInput(value: $prototypeMph, step: 5, accent: .mauve)
                }
                Field(label: "Scale (1:N)") {
                    NumberInput(value: $n, step: 1, accent: .mauve)
                }
                Field(label: "Model Wheel Ø", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($wheelDiaIn, system: system),
                                step: system == .metric ? 10 : 1,
                                accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Scale Speed",
                        value: String(format: "%.2f", result.scaleMph),
                        unit: "mph",
                        accent: .mauve)
                Readout(label: "Wheel RPM",
                        value: String(Int(result.wheelRPM.rounded())),
                        unit: "RPM",
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        ScaleSpeedSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
