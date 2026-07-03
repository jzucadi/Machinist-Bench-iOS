import SwiftUI

struct CarScalesSubView: View {
    let system: UnitSystem

    @State private var dimIn: Double = 1.0   // stored in inches
    @State private var n: Double = 24.0

    private var modelSizeIn: Double {
        guard n > 0 else { return 0 }
        return scaleModel(full: dimIn, n: n).model
    }

    private var modelDisplay: String {
        if system == .metric {
            return String(format: "%.3f", modelSizeIn * 25.4)
        } else {
            return String(format: "%.4f", modelSizeIn)
        }
    }
    private var modelUnit: String { system == .metric ? "mm" : "in" }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Full-Size Dimension", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($dimIn, system: system),
                                step: system == .metric ? 10 : 1,
                                accent: .mauve)
                }
                Field(label: "Scale (1:N)") {
                    NumberInput(value: $n, step: 1, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            // Preset buttons
            VStack(alignment: .leading, spacing: 6) {
                Text("Car Scales")
                    .font(AppFont.mono(11))
                    .foregroundStyle(Catppuccin.subtext0)
                FlowLayout(spacing: 6) {
                    ForEach(ScalePresets.car, id: \.name) { preset in
                        Button(preset.name) { n = preset.n }
                            .font(AppFont.mono(11))
                            .foregroundStyle(Catppuccin.mauve)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Catppuccin.mauve.opacity(0.3)))
                    }
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Model Size",
                        value: modelDisplay,
                        unit: modelUnit,
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        CarScalesSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
