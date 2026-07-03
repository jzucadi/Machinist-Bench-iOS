import SwiftUI

struct SineBarSubView: View {
    let system: UnitSystem

    // Bar length stored in inches; Picker tags are inches
    @State private var barLengthIn: Double = 5.0
    @State private var degrees: Double = 30
    @State private var minutes: Double = 0
    @State private var seconds: Double = 0

    private var result: (stackIn: Double, decimalDeg: Double) {
        sineBarStack(barLengthIn: barLengthIn, degrees: degrees, minutes: minutes, seconds: seconds)
    }

    private var stackDisplay: String {
        if system == .metric {
            return String(format: "%.3f", result.stackIn * 25.4)
        } else {
            return String(format: "%.4f", result.stackIn)
        }
    }

    private var stackUnit: String { system == .metric ? "mm" : "in" }

    // Imperial bar lengths (in inches) and their display labels
    private let imperialLengths: [(Double, String)] = [(5.0, "5\""), (10.0, "10\""), (2.5, "2.5\"")]
    // Metric bar lengths stored as inch equivalents (100mm/25.4, 200mm/25.4, 250mm/25.4)
    private let metricLengths: [(Double, String)] = [
        (100.0 / 25.4, "100 mm"),
        (200.0 / 25.4, "200 mm"),
        (250.0 / 25.4, "250 mm")
    ]

    private var lengths: [(Double, String)] {
        system == .metric ? metricLengths : imperialLengths
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .blue) {
                Field(label: "Bar Length") {
                    Picker("Bar Length", selection: $barLengthIn) {
                        ForEach(lengths, id: \.0) { val, label in
                            Text(label).tag(val)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Catppuccin.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Catppuccin.blue.opacity(0.2)))
                }
                Field(label: "Degrees", hint: "°") {
                    NumberInput(value: $degrees, step: 1, accent: .blue)
                }
                Field(label: "Minutes", hint: "′") {
                    NumberInput(value: $minutes, step: 1, accent: .blue)
                }
                Field(label: "Seconds", hint: "″") {
                    NumberInput(value: $seconds, step: 1, accent: .blue)
                }
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .blue) {
                Readout(label: "Gauge Block Stack",
                        value: stackDisplay,
                        unit: stackUnit,
                        accent: .blue)
                Readout(label: "Decimal Angle",
                        value: String(format: "%.4f°", result.decimalDeg),
                        unit: "",
                        accent: .blue)
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        SineBarSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
