import SwiftUI

struct ScaleConverterSubView: View {
    let system: UnitSystem

    @State private var fullSizeIn: Double = 1.0   // stored in inches
    @State private var n: Double = 87.0

    private var result: (model: Double, area: Double, vol: Double) {
        guard n > 0 else { return (0, 0, 0) }
        return scaleModel(full: fullSizeIn, n: n)
    }

    // MARK: Display helpers

    private var modelDisplay: String {
        if system == .metric {
            return String(format: "%.3f", result.model * 25.4)
        } else {
            return String(format: "%.4f", result.model)
        }
    }
    private var modelUnit: String { system == .metric ? "mm" : "in" }

    private var areaDisplay: String {
        if system == .metric {
            return String(format: "%.3f", result.area * 645.16)
        } else {
            return String(format: "%.6f", result.area)
        }
    }
    private var areaUnit: String { system == .metric ? "mm²" : "in²" }

    private var volDisplay: String {
        if system == .metric {
            return String(format: "%.4f", result.vol * 16.387064)
        } else {
            return String(format: "%.6f", result.vol)
        }
    }
    private var volUnit: String { system == .metric ? "cm³" : "in³" }

    var body: some View {
        VStack(spacing: 16) {
            Panel(title: "Inputs", accent: .mauve) {
                Field(label: "Full-Size Length", hint: system == .metric ? "mm" : "in") {
                    NumberInput(value: metricLengthBinding($fullSizeIn, system: system),
                                step: system == .metric ? 10 : 1,
                                accent: .mauve)
                }
                Field(label: "Scale (1:N)") {
                    NumberInput(value: $n, step: 1, accent: .mauve)
                }
            }
            .padding(.horizontal, 16)

            // Preset buttons
            VStack(alignment: .leading, spacing: 10) {
                presetGroup(title: "Rail", presets: ScalePresets.rail)
                presetGroup(title: "Garden", presets: ScalePresets.garden)
                presetGroup(title: "Live Steam", presets: ScalePresets.liveSteam)
            }
            .padding(.horizontal, 16)

            Panel(title: "Results", accent: .mauve) {
                Readout(label: "Model Size",
                        value: modelDisplay,
                        unit: modelUnit,
                        accent: .mauve)
                Readout(label: "Area (÷N²)",
                        value: areaDisplay,
                        unit: areaUnit,
                        accent: .mauve)
                Readout(label: "Volume (÷N³)",
                        value: volDisplay,
                        unit: volUnit,
                        accent: .mauve)
            }
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func presetGroup(title: String, presets: [ScalePreset]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppFont.mono(11))
                .foregroundStyle(Catppuccin.subtext0)
            FlowLayout(spacing: 6) {
                ForEach(presets, id: \.name) { preset in
                    Button(preset.name) {
                        n = preset.n
                    }
                    .font(AppFont.mono(11))
                    .foregroundStyle(Catppuccin.mauve)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Catppuccin.surface0, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Catppuccin.mauve.opacity(0.3)))
                }
            }
        }
    }
}

// MARK: - Simple flow layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let width = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > width && currentX > 0 {
                currentY += lineHeight + spacing
                currentX = 0
                lineHeight = 0
            }
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            maxWidth = max(maxWidth, currentX - spacing)
        }
        return CGSize(width: maxWidth, height: currentY + lineHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                currentY += lineHeight + spacing
                currentX = bounds.minX
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(size))
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}

#Preview {
    ScrollView {
        ScaleConverterSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
