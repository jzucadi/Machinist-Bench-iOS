import SwiftUI

// TEMP B5 screenshot root — restore to HomeView() before finishing.
@main
struct MachinistsBenchApp: App {
    var body: some Scene {
        WindowGroup {
            ScrollView {
                MicrometerSubView(system: .imperial)
                    .padding(.vertical, 16)
            }
            .defaultScrollAnchor(UnitPoint(x: 0.5, y: 0.62))
            .background(Catppuccin.base)
        }
    }
}
