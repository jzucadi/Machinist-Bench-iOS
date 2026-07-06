import SwiftUI

struct HardnessRefSubView: View {
    let system: UnitSystem

    var body: some View {
        HardnessSubView(system: system)
    }
}

#Preview {
    ScrollView {
        HardnessRefSubView(system: .imperial)
            .padding(.vertical, 16)
    }
    .background(Catppuccin.base)
}
