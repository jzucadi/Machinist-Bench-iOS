import SwiftUI

enum HeatTreatTab: String, CaseIterable {
    case hardenTemper    = "Harden/Temper"
    case temperingColors = "Tempering Colors"
    case nonFerrous      = "Non-Ferrous Anneal"
}

struct HeatTreatSubView: View {
    let system: UnitSystem

    @State private var tab: HeatTreatTab = .hardenTemper

    var body: some View {
        VStack(spacing: 16) {
            NoteView(
                tone: .info,
                text: "Temperatures are in °C throughout. Always verify against material supplier data sheets — heat-treat results vary with section size, furnace atmosphere, and quench agitation."
            )
            .padding(.horizontal, 16)

            Segmented(
                selection: $tab,
                options: HeatTreatTab.allCases.map { ($0, $0.rawValue) },
                accent: .blue
            )
            .padding(.horizontal, 16)

            switch tab {
            case .hardenTemper:
                DataTable(
                    columns: ["Steel", "Harden (°C)", "Quench", "Temper"],
                    rows: RefTables.hardenTemper.map { row in
                        [row.steel, row.hardenC, row.quench, row.temper]
                    },
                    accent: .blue
                )
                .padding(.horizontal, 16)

            case .temperingColors:
                DataTable(
                    columns: ["Color", "Temp (°C)", "Typical Use"],
                    rows: RefTables.temperingColors.map { row in
                        [row.color, String(row.tempC), row.typicalUse]
                    },
                    accent: .blue
                )
                .padding(.horizontal, 16)

            case .nonFerrous:
                DataTable(
                    columns: ["Metal", "Anneal (°C)", "Cool", "Notes"],
                    rows: RefTables.nonFerrousAnneal.map { row in
                        [row.metal, row.annealC, row.cool, row.notes]
                    },
                    accent: .blue
                )
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    ScrollView {
        HeatTreatSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
