import SwiftUI

struct SurfaceFinishSubView: View {
    let system: UnitSystem

    @State private var mode: String = "predict"
    @State private var noseRad: Double = 0.0313   // stored in inches
    @State private var feed: Double = 0.005        // stored in inches/rev
    @State private var targetRaText: String = "32" // µin (imperial) or µm (metric)

    // MARK: - Computed results

    private var predictResult: (rmaxIn: Double, raIn: Double) {
        surfaceRa(feedIPR: feed, noseRadIn: noseRad)
    }

    private var targetRaIn: Double {
        guard let val = Double(targetRaText) else { return 0 }
        if system == .imperial {
            return val * 1e-6
        } else {
            // µm → inches: µm / 1000 / 25.4
            return val / 1000 / 25.4
        }
    }

    private var requiredFeed: Double {
        feedForRa(raIn: targetRaIn, noseRadIn: noseRad)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Mode") {
                    Segmented(selection: $mode,
                              options: [("predict", "Predict Ra"), ("feed", "Feed for Target Ra")],
                              accent: .mauve)
                }
                Field(label: "Nose Radius", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($noseRad, system: system),
                                step: system == .metric ? 0.1 : 0.005,
                                accent: .mauve)
                }
                if mode == "predict" {
                    Field(label: "Feed", hint: system == .metric ? "mm/rev" : "in/rev") {
                        NumberInput(value: metricLengthBinding($feed, system: system),
                                    step: system == .metric ? 0.01 : 0.001,
                                    accent: .mauve)
                    }
                } else {
                    Field(label: "Target Ra", hint: system == .imperial ? "µin" : "µm") {
                        TextField(system == .imperial ? "32" : "0.8", text: $targetRaText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Catppuccin.text)
                    }
                }
            }
            .padding(.horizontal, 16)

            if mode == "predict" {
                Panel(title: "Results", accent: .mauve) {
                    Readout(label: "Theoretical Ra",
                            value: formatRa(predictResult.raIn),
                            unit: system == .imperial ? "µin" : "µm",
                            accent: .mauve)
                    Readout(label: "Peak-to-Valley Rmax",
                            value: formatRa(predictResult.rmaxIn),
                            unit: system == .imperial ? "µin" : "µm",
                            accent: .mauve)
                }
                .padding(.horizontal, 16)
            } else {
                Panel(title: "Results", accent: .mauve) {
                    Readout(label: "Required Feed",
                            value: formatLength(requiredFeed),
                            unit: system == .metric ? "mm/rev" : "in/rev",
                            accent: .mauve)
                }
                .padding(.horizontal, 16)
            }

            Panel(title: "Ra Reference", accent: .mauve) {
                DataTable(
                    columns: ["Finish", "Ra µin", "Ra µm"],
                    rows: [
                        ["Mirror / lapped",  "1–4",     "0.025–0.1"],
                        ["Ground / fine",    "8–16",    "0.2–0.4"],
                        ["Fine turned",      "16–32",   "0.4–0.8"],
                        ["Medium turned",    "32–125",  "0.8–3.2"],
                        ["Rough turned",     "125–500", "3.2–12.5"]
                    ],
                    accent: .mauve
                )
            }
            .padding(.horizontal, 16)
        }
        .onChange(of: system) { _, _ in
            // Reset target Ra text to appropriate default when system changes
            targetRaText = system == .imperial ? "32" : "0.8"
        }
    }

    // MARK: - Helpers

    /// Format a roughness value in inches → µin or µm, 1 decimal place
    private func formatRa(_ valueIn: Double) -> String {
        if system == .imperial {
            return String(format: "%.1f", valueIn * 1e6)
        } else {
            return String(format: "%.1f", valueIn * 25400)
        }
    }

    private func formatLength(_ valueIn: Double) -> String {
        if system == .metric {
            return String(format: "%.4f", valueIn * 25.4)
        } else {
            return String(format: "%.5f", valueIn)
        }
    }
}

#Preview {
    ScrollView {
        SurfaceFinishSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
