import SwiftUI

struct GearSubView: View {
    let system: UnitSystem

    @State private var driveT: Double = 20
    @State private var drivenT: Double = 40
    @State private var rpmIn: Double = 100
    @State private var dp: Double = 20

    private var driveT_int: Int { max(1, Int(driveT.rounded())) }
    private var drivenT_int: Int { max(1, Int(drivenT.rounded())) }

    private var result: GearResult? {
        gearCalc(driveT: driveT_int, drivenT: drivenT_int, rpmIn: rpmIn, dp: dp)
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Drive Teeth") {
                    NumberInput(value: $driveT, step: 1, accent: .mauve)
                }
                Field(label: "Driven Teeth") {
                    NumberInput(value: $drivenT, step: 1, accent: .mauve)
                }
                Field(label: "Input Speed", hint: "RPM") {
                    NumberInput(value: $rpmIn, step: 10, accent: .mauve)
                }
                Field(label: "Diametral Pitch", hint: "teeth/in") {
                    NumberInput(value: $dp, step: 1, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            if let r = result {
                Panel(title: "Results", accent: .mauve) {
                    Readout(label: "Gear Ratio",
                            value: String(format: "%.4f", r.ratio),
                            unit: "",
                            sub: "\(driveT_int)T : \(drivenT_int)T",
                            accent: .mauve)
                    Readout(label: "Output Speed",
                            value: String(format: "%d", Int(r.rpmOut.rounded())),
                            unit: "RPM",
                            accent: .mauve)
                    Readout(label: "Center Distance",
                            value: formatLength(r.centerDistance),
                            unit: system == .metric ? "mm" : "in",
                            accent: .mauve)
                }
                .padding(.horizontal, 16)

                Panel(title: "Gear Geometry", accent: .mauve) {
                    DataTable(
                        columns: ["Gear", "Teeth", "Pitch \u{00D8}", "Outside \u{00D8}"],
                        rows: [
                            ["Driver",
                             "\(driveT_int)",
                             formatLength(r.pdDriver),
                             formatLength(r.odDriver)],
                            ["Driven",
                             "\(drivenT_int)",
                             formatLength(r.pdDriven),
                             formatLength(r.odDriven)]
                        ],
                        accent: .mauve
                    )
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
        GearSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
