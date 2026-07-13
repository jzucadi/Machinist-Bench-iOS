import SwiftUI

struct BarWeightSubView: View {
    let system: UnitSystem

    @State private var shape: BarShape = .round
    @State private var materialKey: String = "steel"
    @State private var d1: Double = 1.0         // stored in inches
    @State private var d2: Double = 1.0         // stored in inches (rect height)
    @State private var wall: Double = 0.125     // stored in inches (tube wall)
    @State private var length: Double = 12.0    // stored in inches

    private static let materials: [String] = [
        "steel", "stainless", "aluminum", "brass", "bronze",
        "copper", "castiron", "titanium", "lead", "nylon"
    ]

    private var result: BarResult? {
        barWeight(shape: shape,
                  materialKey: materialKey,
                  d1In: d1,
                  d2In: d2,
                  wallIn: wall,
                  lengthIn: length)
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Shape") {
                    Segmented(selection: Binding(
                        get: { shapeKey(shape) },
                        set: { shape = barShape($0) }
                    ),
                    options: [
                        ("round",  "Round"),
                        ("tube",   "Tube"),
                        ("square", "Square"),
                        ("hex",    "Hex"),
                        ("rect",   "Rect")
                    ],
                    accent: .mauve)
                }
                Field(label: "Material") {
                    Picker("Material", selection: $materialKey) {
                        ForEach(Self.materials, id: \.self) { key in
                            Text(key.capitalized).tag(key)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Catppuccin.mauve)
                }
                Field(label: d1Label, hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($d1, system: system),
                                step: system == .metric ? 1 : 0.125,
                                accent: .mauve)
                }
                if shape == .rect {
                    Field(label: "Height", hint: system == .metric ? "mm" : "in") {
                        NumberInput(value: metricLengthBinding($d2, system: system),
                                    step: system == .metric ? 1 : 0.125,
                                    accent: .mauve)
                    }
                }
                if shape == .tube {
                    Field(label: "Wall Thickness", hint: system == .metric ? "mm" : "in") {
                        NumberInput(value: metricLengthBinding($wall, system: system),
                                    step: system == .metric ? 0.1 : 0.010,
                                    accent: .mauve)
                    }
                }
                Field(label: "Length", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($length, system: system),
                                step: system == .metric ? 10 : 1,
                                accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            if let r = result {
                Panel(title: "Results", accent: .mauve) {
                    Readout(label: "Weight",
                            value: String(format: "%.3f", system == .metric ? r.kg : r.pounds),
                            unit: system == .metric ? "kg" : "lb",
                            sub: system == .metric ? String(format: "%.3f lb", r.pounds)
                                                   : String(format: "%.3f kg", r.kg),
                            accent: .mauve)
                    Readout(label: system == .metric ? "Per Meter" : "Per Foot",
                            value: String(format: "%.3f", system == .metric ? r.perMeterKg : r.perFootLb),
                            unit: system == .metric ? "kg/m" : "lb/ft",
                            accent: .mauve)
                    Readout(label: "Volume",
                            value: system == .metric ? String(format: "%.1f", r.volCuIn * 16.387064)
                                                     : String(format: "%.3f", r.volCuIn),
                            unit: system == .metric ? "cm\u{00B3}" : "in\u{00B3}",
                            sub: system == .metric ? String(format: "%.3f in\u{00B3}", r.volCuIn)
                                                   : String(format: "%.1f cm\u{00B3}", r.volCuIn * 16.387064),
                            accent: .mauve)
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Helpers

    private var d1Label: String {
        switch shape {
        case .round:  return "Diameter"
        case .tube:   return "OD"
        case .square: return "Width"
        case .hex:    return "A/F"
        case .rect:   return "Width"
        }
    }

    private func shapeKey(_ s: BarShape) -> String {
        switch s {
        case .round:  return "round"
        case .tube:   return "tube"
        case .square: return "square"
        case .hex:    return "hex"
        case .rect:   return "rect"
        }
    }

    private func barShape(_ key: String) -> BarShape {
        switch key {
        case "tube":   return .tube
        case "square": return .square
        case "hex":    return .hex
        case "rect":   return .rect
        default:       return .round
        }
    }
}

#Preview {
    ScrollView {
        BarWeightSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
