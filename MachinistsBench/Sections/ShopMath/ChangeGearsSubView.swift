import SwiftUI

struct ChangeGearsSubView: View {
    let system: UnitSystem

    @State private var leadscrewType: String = "tpi"
    @State private var leadscrewValue: Double = 8

    @State private var targetType: String = "tpi"
    @State private var targetValue: Double = 11

    @State private var gearsText: String = {
        (ShopMathData.gearSets["imp"] ?? []).map { "\($0)" }.joined(separator: ", ")
    }()

    @State private var compound: Bool = true

    private var availableGears: [Int] {
        gearsText
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }

    private var leadscrewSpec: PitchSpec {
        leadscrewType == "tpi" ? .tpi(leadscrewValue) : .mmPitch(leadscrewValue)
    }

    private var targetSpec: PitchSpec {
        targetType == "tpi" ? .tpi(targetValue) : .mmPitch(targetValue)
    }

    private var calcResult: (requiredRatio: Double, trains: [GearTrain]) {
        changeGears(
            leadscrew: leadscrewSpec,
            target: targetSpec,
            available: availableGears,
            compound: compound
        )
    }

    private func gearTrainString(_ gears: [Int]) -> String {
        if gears.count == 2 {
            return "\(gears[0])/\(gears[1])"
        } else if gears.count == 4 {
            return "\(gears[0])/\(gears[1]) × \(gears[2])/\(gears[3])"
        } else {
            return gears.map { "\($0)" }.joined(separator: "/")
        }
    }

    private func resultString(for train: GearTrain) -> String {
        // Effective pitch in mm = train.ratio × leadscrew pitch in mm
        let leadscrewMm = leadscrewSpec.mm
        let effectiveMm = train.ratio * leadscrewMm
        let effectiveTPI = 25.4 / effectiveMm
        return String(format: "%.2f TPI · %.3f mm", effectiveTPI, effectiveMm)
    }

    private func errorString(for train: GearTrain) -> String {
        train.errorPct < 1e-3 ? "exact" : String(format: "%.3f%%", train.errorPct)
    }

    private var tableRows: [[String]] {
        calcResult.trains.map { train in
            [gearTrainString(train.gears), resultString(for: train), errorString(for: train)]
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Leadscrew", accent: .mauve) {
                Field(label: "Type") {
                    Segmented(
                        selection: $leadscrewType,
                        options: [("tpi", "TPI"), ("mm", "mm pitch")],
                        accent: .mauve
                    )
                }
                Field(label: "Value", hint: leadscrewType == "tpi" ? "TPI" : "mm") {
                    NumberInput(value: $leadscrewValue, step: leadscrewType == "tpi" ? 1 : 0.25, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Target Pitch", accent: .mauve) {
                Field(label: "Type") {
                    Segmented(
                        selection: $targetType,
                        options: [("tpi", "TPI"), ("mm", "mm pitch")],
                        accent: .mauve
                    )
                }
                Field(label: "Value", hint: targetType == "tpi" ? "TPI" : "mm") {
                    NumberInput(value: $targetValue, step: targetType == "tpi" ? 1 : 0.25, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Available Gears", accent: .mauve) {
                Field(label: "Gear Teeth") {
                    TextField("e.g. 20, 30, 40, 60", text: $gearsText)
                        .keyboardType(.numbersAndPunctuation)
                        .font(AppFont.mono(14))
                        .foregroundStyle(Catppuccin.text)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Catppuccin.mauve.opacity(0.2)))
                }
                HStack(spacing: 8) {
                    presetButton("Imperial") {
                        setGears("imp")
                    }
                    presetButton("Metric +127") {
                        setGears("met")
                    }
                    presetButton("Mini") {
                        setGears("mini")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 4)

                Field(label: "Compound") {
                    Toggle("", isOn: $compound)
                        .tint(Catppuccin.mauve)
                        .labelsHidden()
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(
                    label: "Required Ratio",
                    value: String(format: "%.5f", calcResult.requiredRatio),
                    unit: "",
                    accent: .mauve
                )
            }
            .padding(.horizontal, 16)

            if tableRows.isEmpty {
                NoteView(tone: .warn, text: "No gear trains found within 2% error. Try adding more gears or enabling compound mode.")
                    .padding(.horizontal, 16)
            } else {
                Panel(title: "Gear Trains", accent: .mauve) {
                    DataTable(
                        columns: ["Gear Train", "Result", "Error"],
                        rows: tableRows,
                        accent: .mauve
                    )
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Helpers

    private func setGears(_ key: String) {
        let gears = ShopMathData.gearSets[key] ?? []
        gearsText = gears.map { "\($0)" }.joined(separator: ", ")
    }

    @ViewBuilder
    private func presetButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(AppFont.body(12))
                .foregroundStyle(Catppuccin.mauve)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Catppuccin.mauve.opacity(0.12), in: RoundedRectangle(cornerRadius: 6))
                .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Catppuccin.mauve.opacity(0.3)))
        }
    }
}

#Preview {
    ScrollView {
        ChangeGearsSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
