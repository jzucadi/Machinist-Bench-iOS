import SwiftUI

struct ConverterView: View {
    @State private var categoryKey = "len"
    @State private var value: Double = 1
    @State private var fromKey = "in"

    private var category: ConvCategory {
        Converter.category(categoryKey)!
    }

    private var tableRows: [[String]] {
        category.units.map { unit in
            let converted = convert(category: category, fromKey: fromKey, toKey: unit.key, value: value) ?? 0
            return [unit.label, fmtConv(converted, unitKey: unit.key)]
        }
    }

    private var fractionString: String {
        guard let inches = convert(category: category, fromKey: fromKey, toKey: "in", value: value) else {
            return "—"
        }
        return nearestSixtyFourths(inches)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Panel(title: "Convert", accent: .blue) {
                    Field(label: "Category") {
                        Picker("", selection: $categoryKey) {
                            ForEach(Converter.categories, id: \.key) { cat in
                                Text(cat.name).tag(cat.key)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Catppuccin.blue)
                    }
                    Field(label: "Value") {
                        NumberInput(value: $value, step: 1, accent: .blue)
                    }
                    Field(label: "From") {
                        Picker("", selection: $fromKey) {
                            ForEach(category.units, id: \.key) { unit in
                                Text(unit.label).tag(unit.key)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Catppuccin.blue)
                    }
                }

                Panel(title: "Results", accent: .blue) {
                    DataTable(
                        columns: ["Unit", "Value"],
                        rows: tableRows,
                        accent: .blue
                    )
                }

                if categoryKey == "len" {
                    Panel(title: "Fraction", accent: .blue) {
                        Readout(label: "As fraction", value: fractionString, unit: "in", accent: .blue)
                    }
                }
            }
            .padding(16)
        }
        .background(Catppuccin.base)
        .onChange(of: categoryKey) {
            fromKey = category.units.first?.key ?? ""
        }
    }

    // MARK: - Fraction helper

    private func nearestSixtyFourths(_ inches: Double) -> String {
        let sixtyfourths = Int((inches * 64).rounded())
        let whole = sixtyfourths / 64
        let remainder = sixtyfourths % 64

        if remainder == 0 {
            return whole == 0 ? "0" : "\(whole)"
        }

        // Reduce the fraction by GCD
        var a = remainder
        var b = 64
        while a % 2 == 0 && b % 2 == 0 {
            a /= 2
            b /= 2
        }

        if whole == 0 {
            return "\(a)/\(b)"
        } else {
            return "\(whole)-\(a)/\(b)"
        }
    }
}

#Preview {
    NavigationStack { ConverterView().navigationTitle("Converter") }
}
