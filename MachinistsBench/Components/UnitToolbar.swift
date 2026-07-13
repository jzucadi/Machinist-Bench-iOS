import SwiftUI

// Imperial/Metric segmented toggle, backed by the shared @AppStorage unit setting.
// Apply `.unitToolbar()` to any screen so the toggle appears in its navigation bar.
struct UnitToolbar: ViewModifier {
    @AppStorage("unitSystem") private var unitRaw = UnitSystem.imperial.rawValue

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top, spacing: 0) { TopFade() }
            .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Picker("Units", selection: $unitRaw) {
                    Text("Imperial").tag(UnitSystem.imperial.rawValue)
                    Text("Metric").tag(UnitSystem.metric.rawValue)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

// Soft partition under the (opaque-when-scrolled) navigation bar: content fades
// out into the bar instead of being cut off at a hard edge.
struct TopFade: View {
    var body: some View {
        LinearGradient(colors: [Catppuccin.base, Catppuccin.base.opacity(0)],
                       startPoint: .top, endPoint: .bottom)
            .frame(height: 24)
            .allowsHitTesting(false)
    }
}

extension View {
    func unitToolbar() -> some View { modifier(UnitToolbar()) }
}
