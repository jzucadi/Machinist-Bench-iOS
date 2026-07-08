import SwiftUI

@main
struct MachinistsBenchApp: App {
    var body: some Scene {
        WindowGroup {
            ScrollView {
                ToolStylesSubView(system: .imperial)
                    .padding(.vertical, 16)
            }
            .background(Catppuccin.base)
        }
    }
}
