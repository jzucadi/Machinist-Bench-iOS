import SwiftUI

struct LoctiteSubView: View {
    let system: UnitSystem

    var body: some View {
        VStack(spacing: 16) {
            NoteView(
                tone: .info,
                text: "Apply a tiny amount to clean, dry, degreased threads. Cure time is 15–30 min (functional) to 24 h (full). Temperature, gap, and substrate affect cure — consult data sheet for critical joints."
            )
            .padding(.horizontal, 16)

            DataTable(
                columns: ["Grade", "Color", "Strength", "Use"],
                rows: RefTables.loctite.map { row in
                    [row.grade, row.color, row.strength, row.use]
                },
                accent: .blue
            )
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        LoctiteSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
