import SwiftUI

enum LayoutTool: String, CaseIterable {
    case sineBar     = "Sine Bar"
    case gaugeStack  = "Gauge-Block Stack"
    case surfacePlate = "Surface Plate"
}

struct LayoutView: View {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue
    private var system: UnitSystem { UnitSystem(rawValue: unitRaw) ?? .imperial }

    @State private var tool: LayoutTool = .sineBar

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Tool picker
                Picker("Tool", selection: $tool) {
                    ForEach(LayoutTool.allCases, id: \.self) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
                .tint(Catppuccin.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                // Sub-view switch
                switch tool {
                case .sineBar:
                    SineBarSubView(system: system)
                case .gaugeStack:
                    GaugeStackSubView(system: system)
                case .surfacePlate:
                    SurfacePlateSubView(system: system)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Catppuccin.base)
        .unitToolbar()
    }
}

#Preview {
    NavigationStack { LayoutView() }
}
