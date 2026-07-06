import SwiftUI

struct SteamSubView: View {
    let system: UnitSystem

    var body: some View {
        VStack(spacing: 16) {
            NoteView(
                tone: .info,
                text: "Saturated steam: temperature is set entirely by pressure. This table shows gauge pressure (above atmospheric). Absolute pressure = gauge + 14.7 psi. Use for boiler design, safety valve settings, and pipe sizing."
            )
            .padding(.horizontal, 16)

            DataTable(
                columns: ["Gauge (psi)", "Abs (psia)", "Temp (°C)", "Temp (°F)"],
                rows: RefTables.steamTable.map { row in
                    [String(row.gaugePSI), row.absPSIA, String(row.tempC), String(row.tempF)]
                },
                accent: .blue
            )
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        SteamSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
