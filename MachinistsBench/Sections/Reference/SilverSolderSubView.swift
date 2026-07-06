import SwiftUI

struct SilverSolderSubView: View {
    let system: UnitSystem

    var body: some View {
        VStack(spacing: 16) {
            NoteView(
                tone: .info,
                text: "Silver brazing requires clean metal and the right flux. Heat the parent metal, not the filler — draw the solder into the joint. Step-braze by using a higher-flow filler first, then a lower-flow filler for subsequent joints."
            )
            .padding(.horizontal, 16)

            DataTable(
                columns: ["Filler", "Ag%", "Flow Point", "Notes"],
                rows: RefTables.silverSolder.map { row in
                    [row.filler, row.silverPct, row.flowPoint, row.notes]
                },
                accent: .blue
            )
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        SilverSolderSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
