import SwiftUI

enum ScaleTool: String, CaseIterable {
    case converter       = "Scale Converter"
    case cars            = "Cars"
    case aircraft        = "Aircraft"
    case boats           = "Boats"
    case fastener        = "Fastener Scale"
    case speed           = "Scale Speed"
    case boiler          = "Boiler Proportions"
    case cylinder        = "Cylinder Power"
}

struct ScaleView: View {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue
    private var system: UnitSystem { UnitSystem(rawValue: unitRaw) ?? .imperial }

    @State private var tool: ScaleTool = .converter

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Tool picker
                Picker("Tool", selection: $tool) {
                    ForEach(ScaleTool.allCases, id: \.self) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
                .tint(Catppuccin.mauve)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                // Sub-view switch
                switch tool {
                case .converter:
                    ScaleConverterSubView(system: system)
                case .cars:
                    CarScalesSubView(system: system)
                case .aircraft:
                    AirScalesSubView(system: system)
                case .boats:
                    BoatScalesSubView(system: system)
                case .fastener:
                    FastenerScaleSubView(system: system)
                case .speed:
                    ScaleSpeedSubView(system: system)
                case .boiler:
                    BoilerPropsSubView(system: system)
                case .cylinder:
                    CylinderPowerSubView(system: system)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Catppuccin.base)
        .unitToolbar()
    }
}

#Preview {
    NavigationStack { ScaleView() }
}
