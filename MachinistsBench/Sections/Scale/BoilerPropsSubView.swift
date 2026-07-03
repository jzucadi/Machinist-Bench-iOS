import SwiftUI

struct BoilerPropsSubView: View {
    let system: UnitSystem

    @State private var boreIn: Double = 1.0    // stored in inches
    @State private var cylinders: Double = 2.0

    private var result: (grateSqIn: Double, heatingSqIn: Double) {
        let cyls = max(1, Int(cylinders.rounded()))
        return boilerProps(boreIn: boreIn, cylinders: cyls)
    }

    private var grateDisplay: String {
        if system == .metric {
            return String(format: "%.2f", result.grateSqIn * 645.16)
        } else {
            return String(format: "%.4f", result.grateSqIn)
        }
    }
    private var grateUnit: String { system == .metric ? "mm²" : "in²" }

    private var heatingDisplay: String {
        if system == .metric {
            return String(format: "%.2f", result.heatingSqIn * 645.16)
        } else {
            return String(format: "%.4f", result.heatingSqIn)
        }
    }
    private var heatingUnit: String { system == .metric ? "mm²" : "in²" }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Cylinder Bore", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($boreIn, system: system),
                                step: system == .metric ? 1 : 0.0625,
                                accent: .mauve)
                }
                Field(label: "Cylinders") {
                    NumberInput(value: $cylinders, step: 1, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Grate Area",
                        value: grateDisplay,
                        unit: grateUnit,
                        accent: .mauve)
                Readout(label: "Heating Surface",
                        value: heatingDisplay,
                        unit: heatingUnit,
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        BoilerPropsSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
