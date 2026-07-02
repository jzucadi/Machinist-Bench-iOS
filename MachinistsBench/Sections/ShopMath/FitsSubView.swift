import SwiftUI

struct FitsSubView: View {
    let system: UnitSystem

    // Panel A — ISO Fit
    @State private var sizeIn: Double = 1.0      // stored in inches
    @State private var fitKey: String = "h7g6"

    // Panel B — Shrink / Press Fit
    @State private var materialKey: String = "lowc"
    @State private var interferenceIn: Double = 0.0015  // stored in inches
    @State private var methodKey: String = "heat"       // "heat" or "cool"

    // MARK: - Fit options

    private struct FitOption {
        let key: String
        let kind: FitKind
        let label: String
        let description: String
    }

    private let fitOptions: [FitOption] = [
        FitOption(key: "h7g6",   kind: .h7g6,   label: "H7/g6",   description: "Sliding (H7/g6) — close running, locates accurately, slides freely."),
        FitOption(key: "h7h6",   kind: .h7h6,   label: "H7/h6",   description: "Locational (H7/h6) — snug hand-assembly, no perceptible play."),
        FitOption(key: "h7k6",   kind: .h7k6,   label: "H7/k6",   description: "Transition (H7/k6) — light press or keyed, slight interference possible."),
        FitOption(key: "h7p6",   kind: .h7p6,   label: "H7/p6",   description: "Press (H7/p6) — interference, permanent or arbor-press assembly."),
        FitOption(key: "h11c11", kind: .h11c11, label: "H11/c11", description: "Loose (H11/c11) — wide clearance, rough or dirty conditions.")
    ]

    private var selectedFit: FitOption {
        fitOptions.first { $0.key == fitKey } ?? fitOptions[0]
    }

    // MARK: - Computed results

    private var fitResult: FitResult {
        isoFit(sizeIn: sizeIn, fit: selectedFit.kind)
    }

    private var shrinkResult: (deltaF: Double, deltaC: Double, targetF: Double, targetC: Double) {
        shrinkFitTemp(
            materialKey: materialKey,
            interferenceIn: interferenceIn,
            diaIn: sizeIn,
            heatHub: methodKey == "heat"
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {

            // MARK: Panel A — ISO 286 Fit

            Panel(title: "ISO 286 Fit", accent: .mauve) {
                Field(label: "Nominal Size", hint: system == .metric ? "mm" : "in") {
                    NumberInput(
                        value: metricLengthBinding($sizeIn, system: system),
                        step: system == .metric ? 1 : 0.125,
                        accent: .mauve
                    )
                }
                Field(label: "Fit Class") {
                    Picker("Fit", selection: $fitKey) {
                        ForEach(fitOptions, id: \.key) { opt in
                            Text(opt.label).tag(opt.key)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Catppuccin.mauve)
                }
                NoteView(tone: .info, text: selectedFit.description)
                    .padding(.horizontal, 2)
            }
            .padding(.horizontal, 16)

            Panel(title: "Fit Results", accent: .mauve) {
                let r = fitResult
                Readout(
                    label: "Hole Tolerance",
                    value: "+\(fmtLen(r.holeEsIn)) / \(fmtLen(r.holeEiIn))",
                    unit: system == .metric ? "mm" : "in",
                    accent: .mauve
                )
                Readout(
                    label: "Shaft Tolerance",
                    value: "\(fmtLen(r.shaftEsIn)) / \(fmtLen(r.shaftEiIn))",
                    unit: system == .metric ? "mm" : "in",
                    accent: .mauve
                )
                clearanceReadout(
                    label: "Min Clearance",
                    interferenceLabel: "Max Interference",
                    valueIn: r.minClearIn
                )
                clearanceReadout(
                    label: "Max Clearance",
                    interferenceLabel: "Min Interference",
                    valueIn: r.maxClearIn
                )
            }
            .padding(.horizontal, 16)

            // MARK: Panel B — Shrink / Press Fit

            Panel(title: "Shrink / Press Fit", accent: .mauve) {
                Field(label: "Material") {
                    Picker("Material", selection: $materialKey) {
                        ForEach(Materials.all, id: \.id) { mat in
                            Text(mat.name).tag(mat.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Catppuccin.mauve)
                }
                Field(label: "Interference", hint: system == .metric ? "mm" : "in") {
                    NumberInput(
                        value: metricLengthBinding($interferenceIn, system: system),
                        step: system == .metric ? 0.01 : 0.0005,
                        accent: .mauve
                    )
                }
                Field(label: "Method") {
                    Segmented(
                        selection: $methodKey,
                        options: [("heat", "Heat Hub"), ("cool", "Cool Shaft")],
                        accent: .mauve
                    )
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Thermal Results", accent: .mauve) {
                let s = shrinkResult
                let deltaLabel = methodKey == "heat" ? "Temperature Rise" : "Temperature Drop"
                let targetLabel = methodKey == "heat" ? "Target Hub Temp" : "Target Shaft Temp"
                if system == .imperial {
                    Readout(label: deltaLabel,
                            value: String(format: "%.0f", s.deltaF),
                            unit: "°F",
                            accent: .mauve)
                    Readout(label: targetLabel,
                            value: String(format: "%.0f", s.targetF),
                            unit: "°F",
                            accent: .mauve)
                } else {
                    Readout(label: deltaLabel,
                            value: String(format: "%.0f", s.deltaC),
                            unit: "°C",
                            accent: .mauve)
                    Readout(label: targetLabel,
                            value: String(format: "%.0f", s.targetC),
                            unit: "°C",
                            accent: .mauve)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Helpers

    /// Format a deviation length in inches, showing 4dp imperial or 4dp mm metric.
    private func fmtLen(_ valueIn: Double) -> String {
        if system == .metric {
            return String(format: "%.4f", valueIn * 25.4)
        } else {
            return String(format: "%.4f", valueIn)
        }
    }

    /// Render a clearance readout, relabelling when value is negative (interference).
    @ViewBuilder
    private func clearanceReadout(label: String, interferenceLabel: String, valueIn: Double) -> some View {
        if valueIn >= 0 {
            Readout(
                label: label,
                value: fmtLen(valueIn),
                unit: system == .metric ? "mm" : "in",
                accent: .mauve
            )
        } else {
            Readout(
                label: interferenceLabel,
                value: fmtLen(abs(valueIn)),
                unit: system == .metric ? "mm" : "in",
                accent: .mauve
            )
        }
    }
}

#Preview {
    ScrollView {
        FitsSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
