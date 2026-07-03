import SwiftUI

struct CylinderPowerSubView: View {
    let system: UnitSystem

    @State private var boreIn: Double = 1.0      // stored in inches
    @State private var strokeIn: Double = 1.5    // stored in inches
    @State private var rpm: Double = 500.0
    @State private var psi: Double = 45.0
    @State private var cutoff: Double = 0.6
    @State private var cylinders: Double = 2.0

    private var result: (watts: Double, hp: Double, steamKgH: Double) {
        let cyls = max(1, Int(cylinders.rounded()))
        return cylinderPower(
            boreIn: boreIn,
            strokeIn: strokeIn,
            rpm: rpm,
            psi: psi,
            cutoff: cutoff,
            cylinders: cyls
        )
    }

    // Piston area: (π/4) × bore² × cylinders (in inches²)
    private var pistonAreaSqIn: Double {
        let cyls = max(1, Int(cylinders.rounded()))
        return Double.pi / 4.0 * boreIn * boreIn * Double(cyls)
    }

    // Power display
    private var powerDisplay: String {
        if system == .metric {
            return String(format: "%.1f", result.watts)
        } else {
            return String(format: "%.3f", result.hp)
        }
    }
    private var powerUnit: String { system == .metric ? "W" : "hp" }
    private var powerSub: String {
        if system == .metric {
            return String(format: "%.3f hp", result.hp)
        } else {
            return String(format: "%.1f W", result.watts)
        }
    }

    // Piston area display
    private var pistonAreaDisplay: String {
        if system == .metric {
            return String(format: "%.2f", pistonAreaSqIn * 645.16)
        } else {
            return String(format: "%.4f", pistonAreaSqIn)
        }
    }
    private var pistonAreaUnit: String { system == .metric ? "mm²" : "in²" }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Cylinder Bore", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($boreIn, system: system),
                                step: system == .metric ? 1 : 0.0625,
                                accent: .mauve)
                }
                Field(label: "Stroke", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($strokeIn, system: system),
                                step: system == .metric ? 1 : 0.0625,
                                accent: .mauve)
                }
                Field(label: "RPM") {
                    NumberInput(value: $rpm, step: 50, accent: .mauve)
                }
                Field(label: "Pressure", hint: "psi") {
                    NumberInput(value: $psi, step: 5, accent: .mauve)
                }
                Field(label: "Cutoff (0–1)") {
                    NumberInput(value: $cutoff, step: 0.05, accent: .mauve)
                }
                Field(label: "Cylinders") {
                    NumberInput(value: $cylinders, step: 1, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Power",
                        value: powerDisplay,
                        unit: powerUnit,
                        sub: powerSub,
                        accent: .mauve)
                Readout(label: "Steam Rate",
                        value: String(format: "%.2f", result.steamKgH),
                        unit: "kg/h",
                        accent: .mauve)
                Readout(label: "Piston Area",
                        value: pistonAreaDisplay,
                        unit: pistonAreaUnit,
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        CylinderPowerSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
