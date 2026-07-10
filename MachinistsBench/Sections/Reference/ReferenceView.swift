import SwiftUI

/// Final 14-case web picker order (app-new.html line 4197).
enum ReferenceTool: String, CaseIterable {
    case inserts         = "Inserts"
    case toolStyles      = "Tool Styles"
    case drillSharpening = "Drill Sharpening"
    case micrometer      = "Micrometer"
    case files           = "Files"
    case prints          = "Print Symbols"
    case loctite         = "Loctite"
    case modelThreads    = "Model Threads"
    case silverSolder    = "Silver Solder"
    case steam           = "Steam"
    case hardness        = "Hardness"
    case heatTreat       = "Heat Treat"
    case grinding        = "Grinding"
    case tapersCollets   = "Tapers & Collets"
}

struct ReferenceView: View {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue
    private var system: UnitSystem { UnitSystem(rawValue: unitRaw) ?? .imperial }

    // Web default view (app-new.html line 4188: useState("inserts")).
    @State private var tool: ReferenceTool = .inserts

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
                case .inserts:
                    InsertsSubView(system: system)
                case .toolStyles:
                    ToolStylesSubView(system: system)
                case .drillSharpening:
                    DrillSharpeningSubView(system: system)
                case .micrometer:
                    MicrometerSubView(system: system)
                case .files:
                    FilesSubView(system: system)
                case .prints:
                    PrintsSubView(system: system)
                case .loctite:
                    LoctiteSubView(system: system)
                case .modelThreads:
                    ModelThreadsSubView(system: system)
                case .silverSolder:
                    SilverSolderSubView(system: system)
                case .steam:
                    SteamSubView(system: system)
                case .hardness:
                    HardnessRefSubView(system: system)
                case .heatTreat:
                    HeatTreatSubView(system: system)
                case .grinding:
                    GrindingSubView(system: system)
                case .tapersCollets:
                    TapersColletsSubView(system: system)
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
