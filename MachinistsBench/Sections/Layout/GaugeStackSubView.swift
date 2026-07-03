import SwiftUI

struct GaugeStackSubView: View {
    let system: UnitSystem

    @State private var metric: Bool = false
    @State private var target: Double = 1.0

    private var blocks: [Double]? {
        gaugeStack(targetIn: target, metric: metric)
    }

    private var unitLabel: String { metric ? "mm" : "in" }

    private var tableRows: [[String]] {
        (blocks ?? []).map { [String(format: "%.4f", $0)] }
    }

    private var blockCount: Int { blocks?.count ?? 0 }

    private var blockSum: Double { blocks?.reduce(0, +) ?? 0 }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .blue) {
                Field(label: "Gauge Block Set") {
                    Segmented(
                        selection: $metric,
                        options: [(false, "Inch"), (true, "Metric")],
                        accent: .blue
                    )
                }
                Field(label: "Target Size", hint: unitLabel) {
                    NumberInput(value: $target,
                                step: metric ? 0.5 : 0.0001,
                                accent: .blue)
                }
            }
            .padding(.horizontal, 16)

            if let blocks {
                Panel(title: "Block Stack", accent: .blue) {
                    DataTable(
                        columns: ["Block (\(metric ? "mm" : "in"))"],
                        rows: tableRows,
                        accent: .blue
                    )
                    Readout(label: "Blocks",
                            value: "\(blockCount)",
                            unit: "",
                            accent: .blue)
                    Readout(label: "Sum",
                            value: String(format: "%.4f", blockSum),
                            unit: unitLabel,
                            accent: .blue)
                }
                .padding(.horizontal, 16)
            } else {
                Panel(title: "Block Stack", accent: .blue) {
                    NoteView(tone: .warn,
                             text: "No exact stack for that size in this set.")
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    ScrollView {
        GaugeStackSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
