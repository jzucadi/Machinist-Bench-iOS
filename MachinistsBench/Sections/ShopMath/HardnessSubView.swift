import SwiftUI

struct HardnessSubView: View {
    let system: UnitSystem

    @State private var scaleKey: String = "hrc"
    @State private var value: Double = 45

    private var scale: HScale {
        switch scaleKey {
        case "hrb":     return .hrb
        case "brinell": return .brinell
        case "vickers": return .vickers
        default:        return .hrc
        }
    }

    private var result: HardnessResult {
        hardnessConvert(scale: scale, value: value)
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Input Scale") {
                    Segmented(
                        selection: $scaleKey,
                        options: [
                            ("hrc",     "HRC"),
                            ("hrb",     "HRB"),
                            ("brinell", "Brinell"),
                            ("vickers", "Vickers")
                        ],
                        accent: .mauve
                    )
                }
                Field(label: "Value") {
                    NumberInput(value: $value, step: 1, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Rockwell C",
                        value: fmt1(result.hrc),
                        unit: "HRC",
                        accent: .mauve)
                Readout(label: "Rockwell B",
                        value: fmt1(result.hrb),
                        unit: "HRB",
                        accent: .mauve)
                Readout(label: "Brinell",
                        value: fmt0(result.hb),
                        unit: "HB",
                        accent: .mauve)
                Readout(label: "Vickers",
                        value: fmt0(result.hv),
                        unit: "HV",
                        accent: .mauve)
                Readout(label: "Tensile UTS",
                        value: fmt0(result.utsKsi),
                        unit: "ksi",
                        sub: result.utsKsi.map { String(format: "%.0f MPa", $0 * 6.895) } ?? "",
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Helpers

    private func fmt1(_ v: Double?) -> String {
        guard let v else { return "—" }
        return String(format: "%.1f", v)
    }

    private func fmt0(_ v: Double?) -> String {
        guard let v else { return "—" }
        return String(format: "%.0f", v)
    }
}

#Preview {
    ScrollView {
        HardnessSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
