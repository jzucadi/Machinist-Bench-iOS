import SwiftUI

struct SurfacePlateSubView: View {
    let system: UnitSystem

    var body: some View {
        Panel(title: "Surface Plate", accent: .blue) {
            NoteView(
                tone: .info,
                text: "To scribe a height off a surface plate, set a height gauge or surface gauge to the desired dimension and lock it. Place the workpiece on the plate and slide the gauge along the surface, lightly dragging the scriber tip across the part to mark a precise horizontal line. The surface plate acts as the datum — any height measured from it is repeatable to the flatness of the plate itself."
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ScrollView {
        SurfacePlateSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
