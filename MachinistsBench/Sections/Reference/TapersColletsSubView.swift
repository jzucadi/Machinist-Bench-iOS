import SwiftUI

enum TapersColletsTab: String, CaseIterable {
    case morse       = "Morse"
    case er          = "ER"
    case workholding = "Workholding"
}

struct TapersColletsSubView: View {
    let system: UnitSystem

    @State private var tab: TapersColletsTab = .morse

    var body: some View {
        VStack(spacing: 16) {
            Segmented(
                selection: $tab,
                options: TapersColletsTab.allCases.map { ($0, $0.rawValue) },
                accent: .blue
            )
            .padding(.horizontal, 16)

            switch tab {
            case .morse:
                VStack(spacing: 8) {
                    NoteView(
                        tone: .info,
                        text: "Morse Tapers are self-holding. They lock by friction when driven in and release with a tang or drift. MT2 is standard on most model-shop lathes; MT3/MT4 on larger machines."
                    )
                    .padding(.horizontal, 16)

                    DataTable(
                        columns: ["Size", "Taper/ft", "Large Ø", "Small Ø", "Plug Depth"],
                        rows: RefTables.morseTapers.map { row in
                            [row.size, row.taperPerFt, row.largeDia, row.smallDia, row.plugDepth]
                        },
                        accent: .blue
                    )
                    .padding(.horizontal, 16)
                }

            case .er:
                VStack(spacing: 8) {
                    NoteView(
                        tone: .info,
                        text: "ER collets (DIN 6499) are the most common precision collet system. Each collet closes 1 mm (0.5 mm for small sizes). Runout is typically < 0.01 mm when properly torqued."
                    )
                    .padding(.horizontal, 16)

                    DataTable(
                        columns: ["Series", "Capacity", "Range/Collet", "Typical Use"],
                        rows: RefTables.erCollets.map { row in
                            [row.series, row.capacity, row.colletRange, row.typicalHome]
                        },
                        accent: .blue
                    )
                    .padding(.horizontal, 16)
                }

            case .workholding:
                VStack(spacing: 8) {
                    NoteView(
                        tone: .info,
                        text: "Other common workholding taper systems found in the home shop. Each system has a distinct geometry — adapters exist but verify concentricity before relying on them for precision work."
                    )
                    .padding(.horizontal, 16)

                    DataTable(
                        columns: ["System", "Key Facts"],
                        rows: RefTables.workholdingTapers.map { row in
                            [row.system, row.keyFacts]
                        },
                        accent: .blue
                    )
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        TapersColletsSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
