import SwiftUI

struct ThreadsView: View {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue
    private var system: UnitSystem { UnitSystem(rawValue: unitRaw) ?? .imperial }

    // Finder inputs (stored in inches)
    @State private var diameter: Double = 0.25
    @State private var engagementPct: Double = 75

    // Family browser
    @State private var selectedFamily: String = "un"

    // MARK: - Computed: Finder

    private var rawImperialDia: Double { diameter }

    private var nearestResults: [ThreadSpec] {
        nearestThreads(toDiaIn: rawImperialDia, count: 6)
    }

    private var finderRows: [[String]] {
        nearestResults.map { spec in
            let tapIn = tapDrillIn(majorIn: spec.majorIn, pitchIn: spec.pitchIn, engagementPct: engagementPct)
            let clearIn = threadClearanceIn(majorIn: spec.majorIn)
            let drillName = Drills.nearestInch(tapIn).name

            let majorStr: String
            let pitchStr: String
            let tapStr: String
            let clearStr: String

            if system == .metric {
                majorStr = String(format: "%.3f mm", spec.majorIn * 25.4)
                pitchStr = String(format: "%.3f mm", spec.pitchIn * 25.4)
                tapStr   = String(format: "%.3f mm (%@)", tapIn * 25.4, drillName)
                clearStr = String(format: "%.3f mm", clearIn * 25.4)
            } else {
                majorStr = String(format: "%.4f\"", spec.majorIn)
                pitchStr = String(format: "%.4f\"", spec.pitchIn)
                tapStr   = String(format: "%.4f\" (%@)", tapIn, drillName)
                clearStr = String(format: "%.4f\"", clearIn)
            }

            return [spec.name, majorStr, pitchStr, tapStr, clearStr]
        }
    }

    // MARK: - Computed: Family Browser

    private let familyOrder: [String] = ["un", "metric", "ba", "bsw", "bsf", "bsb", "bsc", "bsp", "npt", "thury", "me", "photo"]

    private let familyLabels: [String: String] = [
        "un":     "Unified",
        "metric": "Metric",
        "ba":     "BA",
        "bsw":    "BSW",
        "bsf":    "BSF",
        "bsb":    "BS Brass",
        "bsc":    "BS Cycle",
        "bsp":    "BSP",
        "npt":    "NPT",
        "thury":  "Thury",
        "me":     "ME",
        "photo":  "Photo/Camera",
    ]

    private var familyThreads: [ThreadSpec] {
        ThreadFamilies.all.filter { $0.family == selectedFamily }
    }

    private var familyRows: [[String]] {
        familyThreads.map { spec in
            let majorStr: String
            let pitchStr: String
            if system == .metric {
                majorStr = String(format: "%.3f mm", spec.majorIn * 25.4)
                pitchStr = String(format: "%.3f mm", spec.pitchIn * 25.4)
            } else {
                majorStr = String(format: "%.4f\"", spec.majorIn)
                pitchStr = String(format: "%.4f\"", spec.pitchIn)
            }
            return [spec.name, majorStr, pitchStr]
        }
    }

    // MARK: - Computed: Torque

    private var torqueRows: [[String]] {
        let entries = system == .metric ? TorqueCharts.metric : TorqueCharts.inch
        return entries.map { e in
            let unitLabel = e.unit == "in" ? "in·lb" : "ft·lb"
            return [
                e.thread,
                "\(formatTorque(e.steelValue)) \(unitLabel)",
                "\(formatTorque(e.softValue)) \(unitLabel)",
            ]
        }
    }

    private func formatTorque(_ v: Double) -> String {
        v.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(v))" : String(format: "%.1f", v)
    }

    // MARK: - Camera Mounts

    private var mountRows: [[String]] {
        CameraMounts.all.map { m in
            [m.mount, m.mountType, m.threadOrThroat, m.flangeDistMm]
        }
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                finderPanel
                familyPanel
                torquePanel
                cameraMountsPanel
            }
            .padding(16)
        }
        .background(Catppuccin.base)
        .unitToolbar()
    }

    // MARK: - Finder Panel

    @ViewBuilder private var finderPanel: some View {
        Panel(title: "Thread Finder", accent: .blue,
              subtitle: "Nearest 6 threads by major diameter") {
            Field(label: "Diameter", hint: system == .metric ? "mm" : "in") {
                NumberInput(
                    value: metricLengthBinding($diameter, system: system),
                    step: system == .metric ? 0.5 : 0.0625,
                    accent: .blue
                )
            }
            Field(label: "Engagement", hint: "%") {
                NumberInput(value: $engagementPct, step: 5, accent: .blue)
            }
        }

        Panel(title: "Nearest Threads", accent: .blue) {
            DataTable(
                columns: ["Thread", "Major", "Pitch", "Tap Drill", "Clearance"],
                rows: finderRows,
                accent: .blue
            )
        }
    }

    // MARK: - Family Browser Panel

    @ViewBuilder private var familyPanel: some View {
        Panel(title: "Family Browser", accent: .blue,
              subtitle: "Browse all threads in a family") {
            Field(label: "Family") {
                Picker("", selection: $selectedFamily) {
                    ForEach(familyOrder, id: \.self) { key in
                        Text(familyLabels[key] ?? key).tag(key)
                    }
                }
                .pickerStyle(.menu)
                .tint(Catppuccin.blue)
            }

            DataTable(
                columns: ["Thread", "Major", "Pitch"],
                rows: familyRows,
                accent: .blue
            )
        }
    }

    // MARK: - Torque Panel

    @ViewBuilder private var torquePanel: some View {
        Panel(
            title: "Torque Reference",
            accent: .blue,
            subtitle: system == .metric ? "ISO 8.8, dry threads (K≈0.2)" : "SAE Grade 5, dry threads (K≈0.2)"
        ) {
            DataTable(
                columns: ["Thread", "Steel", "Soft (Al/Fe/Br)"],
                rows: torqueRows,
                accent: .blue
            )
        }
    }

    // MARK: - Camera Mounts Panel

    @ViewBuilder private var cameraMountsPanel: some View {
        Panel(title: "Camera Mounts", accent: .blue,
              subtitle: "Bayonet and screw lens mounts") {
            DataTable(
                columns: ["Mount", "Type", "Thread/Throat", "Flange"],
                rows: mountRows,
                accent: .blue
            )
        }
    }
}

#Preview {
    NavigationStack { ThreadsView().navigationTitle("Threads") }
}
