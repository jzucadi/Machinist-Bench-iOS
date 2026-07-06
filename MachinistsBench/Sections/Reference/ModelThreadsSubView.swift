import SwiftUI

enum ModelThreadTab: String, CaseIterable {
    case ba  = "BA"
    case me  = "ME"
    case bsw = "BSW"
}

struct ModelThreadsSubView: View {
    let system: UnitSystem

    @State private var tab: ModelThreadTab = .ba

    var body: some View {
        VStack(spacing: 16) {
            Segmented(
                selection: $tab,
                options: ModelThreadTab.allCases.map { ($0, $0.rawValue) },
                accent: .blue
            )
            .padding(.horizontal, 16)

            switch tab {
            case .ba:
                VStack(spacing: 8) {
                    NoteView(
                        tone: .info,
                        text: "BA (British Association) threads use a 47.5° included angle. Commonly found on instrument work, clocks, and older British model engineering fittings."
                    )
                    .padding(.horizontal, 16)

                    DataTable(
                        columns: ["Size", "Major (mm)", "Pitch (mm)", "~TPI", "Tap Drill"],
                        rows: RefTables.baThreads.map { row in
                            [
                                row.size,
                                String(format: "%.1f", row.majorMM),
                                String(format: "%.2f", row.pitchMM),
                                String(format: "%.1f", row.approxTPI),
                                row.tapDrill
                            ]
                        },
                        accent: .blue
                    )
                    .padding(.horizontal, 16)
                }

            case .me:
                VStack(spacing: 8) {
                    NoteView(
                        tone: .info,
                        text: "ME (Model Engineer) threads use a 55° Whitworth form. The 1/4″ × 40 is the de-facto standard for steam fittings, unions, and bushes in 3½″ and 5″ gauge locomotives."
                    )
                    .padding(.horizontal, 16)

                    DataTable(
                        columns: ["Size", "TPI", "Tap Drill", "Common Use"],
                        rows: RefTables.meThreads.map { row in
                            [row.size, "\(row.tpi)", row.tapDrill, row.commonUse]
                        },
                        accent: .blue
                    )
                    .padding(.horizontal, 16)
                }

            case .bsw:
                VStack(spacing: 8) {
                    NoteView(
                        tone: .info,
                        text: "BSW (British Standard Whitworth) uses a 55° included angle with rounded roots and crests. Still common on older British machinery and some model engineering fittings."
                    )
                    .padding(.horizontal, 16)

                    DataTable(
                        columns: ["Size", "TPI", "Tap Drill"],
                        rows: RefTables.bswThreads.map { row in
                            [row.size, "\(row.tpi)", row.tapDrill]
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
        ModelThreadsSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
