import SwiftUI

enum ShopMathTool: String, CaseIterable {
    case boltPattern  = "Bolt Pattern"
    case dividingHead = "Dividing Head"
    case hexPoly      = "Hex / Poly"
    case rightTriangle = "Right Triangle"
    case gearRatio    = "Gear Ratio"
    case changeGears  = "Change Gears"
    case taper        = "Taper"
    case fitsAndTol   = "Fits & Tol."
    case knurling     = "Knurling"
    case surfaceFinish = "Surface Finish"
    case hardness     = "Hardness"
    case barWeight    = "Bar Weight"
    case wireSheet    = "Wire / Sheet"
}

struct ShopMathView: View {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue
    private var system: UnitSystem { UnitSystem(rawValue: unitRaw) ?? .imperial }

    @State private var tool: ShopMathTool = .boltPattern

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Tool picker
                Picker("Tool", selection: $tool) {
                    ForEach(ShopMathTool.allCases, id: \.self) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
                .tint(Catppuccin.mauve)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                // Sub-view switch
                switch tool {
                case .boltPattern:
                    BoltPatternSubView(system: system)
                case .hexPoly:
                    PolygonSubView(system: system)
                case .rightTriangle:
                    RightTriangleSubView(system: system)
                case .taper:
                    TaperSubView(system: system)
                case .gearRatio:
                    GearSubView(system: system)
                case .knurling:
                    KnurlSubView(system: system)
                case .surfaceFinish:
                    SurfaceFinishSubView(system: system)
                case .barWeight:
                    BarWeightSubView(system: system)
                case .dividingHead:
                    DividingHeadSubView(system: system)
                case .changeGears:
                    ChangeGearsSubView(system: system)
                case .hardness:
                    HardnessSubView(system: system)
                case .fitsAndTol:
                    FitsSubView(system: system)
                case .wireSheet:
                    GaugeSubView(system: system)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Catppuccin.base)
        .unitToolbar()
    }
}

#Preview {
    NavigationStack { ShopMathView() }
}
