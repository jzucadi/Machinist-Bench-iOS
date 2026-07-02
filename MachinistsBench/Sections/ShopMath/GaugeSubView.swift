import SwiftUI

struct GaugeSubView: View {
    let system: UnitSystem

    @State private var gaugeSystem: String = "swg"
    @State private var findDia: Double = 0.0   // stored in inches

    private var activeTable: [Gauge] {
        switch gaugeSystem {
        case "awg": return Gauges.awg
        case "uss": return Gauges.uss
        default:    return Gauges.swg
        }
    }

    private var tableTitle: String {
        switch gaugeSystem {
        case "awg": return "AWG Table"
        case "uss": return "US Sheet Table"
        default:    return "SWG Table"
        }
    }

    // find-diameter in inches (respects unit system via metricLengthBinding)
    private var findIn: Double { findDia }

    // nearest-gauge results for each system
    private var nearestSWG: Gauge { Gauges.nearest(Gauges.swg, toIn: findIn) }
    private var nearestAWG: Gauge { Gauges.nearest(Gauges.awg, toIn: findIn) }
    private var nearestUSS: Gauge { Gauges.nearest(Gauges.uss, toIn: findIn) }

    // DataTable rows for the active system
    private var tableRows: [[String]] {
        activeTable.map { g in
            [g.label,
             String(format: "%.4f", g.dia),
             String(format: "%.3f", g.dia * 25.4)]
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Inputs panel
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "System") {
                    Segmented(
                        selection: $gaugeSystem,
                        options: [
                            ("swg", "SWG"),
                            ("awg", "AWG"),
                            ("uss", "US Sheet")
                        ],
                        accent: .mauve
                    )
                }
                Field(label: "Find Diameter", hint: system == .metric ? "mm" : "in") {
                    NumberInput(
                        value: metricLengthBinding($findDia, system: system),
                        step: system == .metric ? 0.1 : 0.001,
                        accent: .mauve
                    )
                }
            }
            .padding(.horizontal, 16)

            // Cross-reference panel (shown when find > 0)
            if findIn > 0 {
                Panel(title: "Cross-Reference", accent: .mauve) {
                    Readout(
                        label: "SWG Gauge \(nearestSWG.label)",
                        value: String(format: "%.4f\"", nearestSWG.dia),
                        unit: "SWG",
                        sub: String(format: "%.3f mm", nearestSWG.dia * 25.4),
                        accent: .mauve
                    )
                    Readout(
                        label: "AWG Gauge \(nearestAWG.label)",
                        value: String(format: "%.4f\"", nearestAWG.dia),
                        unit: "AWG",
                        sub: String(format: "%.3f mm", nearestAWG.dia * 25.4),
                        accent: .mauve
                    )
                    Readout(
                        label: "US Sheet Gauge \(nearestUSS.label)",
                        value: String(format: "%.4f\"", nearestUSS.dia),
                        unit: "USS",
                        sub: String(format: "%.3f mm", nearestUSS.dia * 25.4),
                        accent: .mauve
                    )
                }
                .padding(.horizontal, 16)
            }

            // DataTable for selected system
            Panel(title: tableTitle, accent: .mauve) {
                DataTable(
                    columns: ["Gauge", "inch", "mm"],
                    rows: tableRows,
                    accent: .mauve
                )
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        GaugeSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
