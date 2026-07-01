import SwiftUI

struct RightTriangleSubView: View {
    let system: UnitSystem

    // String-based inputs so they can be empty → nil
    @State private var aStr: String = ""
    @State private var bStr: String = ""
    @State private var hStr: String = ""
    @State private var xStr: String = ""
    @State private var yStr: String = ""

    // Parse strings to optional doubles
    // For length fields: metric input is in mm, convert to inches for calc
    private func parseLengthStr(_ s: String) -> Double? {
        guard !s.isEmpty, let v = Double(s), v > 0 else { return nil }
        return system == .metric ? v / 25.4 : v
    }

    private func parseAngleStr(_ s: String) -> Double? {
        guard !s.isEmpty, let v = Double(s), v > 0 else { return nil }
        return v
    }

    private var result: TriResult? {
        solveRightTriangle(
            a: parseLengthStr(aStr),
            b: parseLengthStr(bStr),
            h: parseLengthStr(hStr),
            angleXDeg: parseAngleStr(xStr),
            angleYDeg: parseAngleStr(yStr)
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Side a", hint: system == .metric ? "mm" : "in") {
                    optionalTextField($aStr)
                }
                Field(label: "Side b", hint: system == .metric ? "mm" : "in") {
                    optionalTextField($bStr)
                }
                Field(label: "Hypotenuse h", hint: system == .metric ? "mm" : "in") {
                    optionalTextField($hStr)
                }
                Field(label: "Angle X", hint: "°") {
                    optionalTextField($xStr)
                }
                Field(label: "Angle Y", hint: "°") {
                    optionalTextField($yStr)
                }
            }
            .padding(.horizontal, 16)

            if let r = result {
                Panel(title: "Results", accent: .mauve) {
                    Readout(label: "Side a",
                            value: formatLength(r.a),
                            unit: system == .metric ? "mm" : "in",
                            accent: .mauve)
                    Readout(label: "Side b",
                            value: formatLength(r.b),
                            unit: system == .metric ? "mm" : "in",
                            accent: .mauve)
                    Readout(label: "Hypotenuse h",
                            value: formatLength(r.h),
                            unit: system == .metric ? "mm" : "in",
                            accent: .mauve)
                    Readout(label: "Angle X",
                            value: String(format: "%.2f", r.angleX),
                            unit: "°",
                            accent: .mauve)
                    Readout(label: "Angle Y",
                            value: String(format: "%.2f", r.angleY),
                            unit: "°",
                            accent: .mauve)
                    Readout(label: "Area",
                            value: formatArea(r.area),
                            unit: system == .metric ? "mm²" : "in²",
                            sub: "Perimeter: \(formatLength(r.perimeter)) \(system == .metric ? "mm" : "in")",
                            accent: .mauve)
                }
                .padding(.horizontal, 16)
            } else {
                NoteView(tone: .info, text: "Enter any two values (two sides, or one side + one angle).")
                    .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Optional Text Field

    @ViewBuilder
    private func optionalTextField(_ text: Binding<String>) -> some View {
        TextField("", text: text)
            .keyboardType(.decimalPad)
            .font(AppFont.mono(16))
            .foregroundStyle(Catppuccin.text)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Catppuccin.mauve.opacity(0.2)))
    }

    // MARK: - Helpers

    private func formatLength(_ valueIn: Double) -> String {
        if system == .metric {
            return String(format: "%.3f", valueIn * 25.4)
        } else {
            return String(format: "%.4f", valueIn)
        }
    }

    private func formatArea(_ areaIn2: Double) -> String {
        if system == .metric {
            return String(format: "%.3f", areaIn2 * 645.16)
        } else {
            return String(format: "%.4f", areaIn2)
        }
    }
}

#Preview {
    ScrollView {
        RightTriangleSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
