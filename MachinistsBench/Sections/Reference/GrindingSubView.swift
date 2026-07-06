import SwiftUI

struct GrindingSubView: View {
    let system: UnitSystem

    var body: some View {
        VStack(spacing: 16) {
            NoteView(
                tone: .info,
                text: "HSS tool angles are starting points — adjust for your machine, surface finish, and cut depth. Use a protractor or angle gauge to verify relief angles. Dress the wheel frequently for best results."
            )
            .padding(.horizontal, 16)

            DataTable(
                columns: ["Material", "Appr Relief", "Front Relief", "Top Rake", "Top Relief"],
                rows: RefTables.hssAngles.map { row in
                    [row.material, row.apprRelief, row.frontRelief, row.topRake, row.topRelief]
                },
                accent: .blue
            )
            .padding(.horizontal, 16)

            DataTable(
                columns: ["Job", "Abrasive", "Grit", "Grade"],
                rows: RefTables.grindingWheels.map { row in
                    [row.job, row.abrasive, row.grit, row.grade]
                },
                accent: .blue
            )
            .padding(.horizontal, 16)

            NoteView(
                tone: .info,
                text: "Grinding-angle diagrams coming in a later update."
            )
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        GrindingSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
