import SwiftUI

enum ReferenceTool: String, CaseIterable {
    case loctite      = "Loctite"
    case modelThreads = "Model Threads"
    case silverSolder = "Silver Solder"
    case tapersCollets = "Tapers & Collets"
    case hardness     = "Hardness"
    case heatTreat    = "Heat Treat"
    case grinding     = "Grinding"
    case steam        = "Steam"
    case toolStyles   = "Tool Styles"
    case files        = "Files"
    case inserts      = "Inserts"
    case drillSharpening = "Drill Sharpening"
    case prints       = "Print Symbols"
}

struct ReferenceView: View {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue
    private var system: UnitSystem { UnitSystem(rawValue: unitRaw) ?? .imperial }

    @State private var tool: ReferenceTool = .loctite

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Tool picker
                Picker("Tool", selection: $tool) {
                    ForEach(ReferenceTool.allCases, id: \.self) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
                .tint(Catppuccin.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                // Sub-view switch
                switch tool {
                case .loctite:
                    LoctiteSubView(system: system)
                case .modelThreads:
                    ModelThreadsSubView(system: system)
                case .silverSolder:
                    SilverSolderSubView(system: system)
                case .tapersCollets:
                    TapersColletsSubView(system: system)
                case .hardness:
                    HardnessRefSubView(system: system)
                case .heatTreat:
                    HeatTreatSubView(system: system)
                case .grinding:
                    GrindingSubView(system: system)
                case .steam:
                    SteamSubView(system: system)
                case .toolStyles:
                    ToolStylesSubView(system: system)
                case .files:
                    FilesSubView(system: system)
                case .inserts:
                    InsertsSubView(system: system)
                case .drillSharpening:
                    DrillSharpeningSubView(system: system)
                case .prints:
                    PrintsSubView(system: system)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Catppuccin.base)
        .unitToolbar()
    }
}

#Preview {
    NavigationStack { ReferenceView() }
}
