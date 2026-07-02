import SwiftUI

struct DividingHeadSubView: View {
    let system: UnitSystem

    @State private var ratio: Int = 40
    @State private var divisions: Double = 24
    @State private var mode: String = "std"

    private let ratioOptions = [40, 60, 90, 5, 72, 100]

    private var divisions_int: Int { max(1, Int(divisions.rounded())) }

    private var result: (wholeTurns: Int, frac: Double, exact: Bool, solutions: [IndexSolution]) {
        dividingHead(ratio: ratio, divisions: divisions_int, ornamental: mode == "ornamental")
    }

    private var crankTurnsString: String {
        let r = result
        if r.wholeTurns > 0 {
            return String(format: "%dT + %.4f", r.wholeTurns, r.frac)
        } else {
            return String(format: "%.4f", r.frac)
        }
    }

    private var tableRows: [[String]] {
        result.solutions.map { sol in
            let advance: String
            if sol.wholeTurns > 0 {
                advance = "\(sol.wholeTurns)T + \(sol.holes)h"
            } else {
                advance = "\(sol.holes) holes"
            }
            return [sol.plate, "\(sol.circle)", advance]
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Head Ratio") {
                    Picker("Ratio", selection: $ratio) {
                        ForEach(ratioOptions, id: \.self) { r in
                            Text("\(r):1").tag(r)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Catppuccin.mauve)
                }
                Field(label: "Divisions") {
                    NumberInput(value: $divisions, step: 1, accent: .mauve)
                }
                Field(label: "Mode") {
                    Segmented(
                        selection: $mode,
                        options: [("std", "B&S / Cincinnati"), ("ornamental", "Ornamental")],
                        accent: .mauve
                    )
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(
                    label: "Crank Turns / Division",
                    value: crankTurnsString,
                    unit: "",
                    accent: .mauve
                )
            }
            .padding(.horizontal, 16)

            if result.exact {
                NoteView(
                    tone: .good,
                    text: "✔ Exactly \(result.wholeTurns) full crank turn\(result.wholeTurns == 1 ? "" : "s") per division — no plate needed."
                )
                .padding(.horizontal, 16)
            } else if result.solutions.isEmpty {
                NoteView(tone: .warn, text: "No exact plate match found.")
                    .padding(.horizontal, 16)
            } else {
                Panel(title: "Indexing Solutions", accent: .mauve) {
                    DataTable(
                        columns: ["Plate", "Circle", "Advance"],
                        rows: tableRows,
                        accent: .mauve
                    )
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    ScrollView {
        DividingHeadSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
