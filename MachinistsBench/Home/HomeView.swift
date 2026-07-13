import SwiftUI
import UIKit

struct HomeView: View {
    init() {
        // Color the navigation titles lavender (no native SwiftUI modifier for this yet).
        // Must set all three appearances; the large title at scroll-top uses scrollEdgeAppearance.
        let lavender = UIColor(Catppuccin.lavender)
        // Scrolled state: opaque base so content never shows through the bar (no hairline —
        // the fade strip below the bar provides the soft edge). At rest: transparent.
        let scrolled = UINavigationBarAppearance()
        scrolled.configureWithOpaqueBackground()
        scrolled.backgroundColor = UIColor(Catppuccin.base)
        scrolled.shadowColor = .clear
        scrolled.largeTitleTextAttributes = [.foregroundColor: lavender]
        scrolled.titleTextAttributes = [.foregroundColor: lavender]
        let atRest = UINavigationBarAppearance()
        atRest.configureWithTransparentBackground()
        atRest.largeTitleTextAttributes = [.foregroundColor: lavender]
        atRest.titleTextAttributes = [.foregroundColor: lavender]
        let bar = UINavigationBar.appearance()
        bar.standardAppearance = scrolled
        bar.scrollEdgeAppearance = atRest
        bar.compactAppearance = scrolled
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(SectionCatalog.groups, id: \.0) { groupName, items in
                    Section {
                        ForEach(items) { item in row(item) }
                    } header: {
                        Text(groupName)
                            .font(AppFont.display(13))
                            .foregroundStyle(Catppuccin.lavender)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Catppuccin.base)
            .safeAreaInset(edge: .top, spacing: 0) { TopFade() }
            .navigationTitle("Pocket Machinist")
        }
        .tint(Catppuccin.blue)
    }

    @ViewBuilder private func row(_ item: SectionItem) -> some View {
        // .listRowBackground must be on the row content List sees (the NavigationLink /
        // top-level label), not inside the link's label, where List ignores it.
        if item.available {
            NavigationLink {
                destination(for: item.id).navigationTitle(item.name)
            } label: { label(item) }
                .listRowBackground(Catppuccin.mantle)
        } else {
            label(item)
                .listRowBackground(Catppuccin.mantle)
        }
    }

    @ViewBuilder private func destination(for id: String) -> some View {
        switch id {
        case "turn": TurningView()
        case "drill": DrillingView()
        case "mill": MillingView()
        case "tap": TappingView()
        case "thread": ThreadingView()
        case "bore": BoringView()
        case "ream": ReamingView()
        case "saw": BandSawView()
        case "math": ShopMathView()
        case "conv": ConverterView()
        case "layout": LayoutView()
        case "scale": ScaleView()
        case "threads": ThreadsView()
        case "rose": RoseEngineView()
        case "ref": ReferenceView()
        default: EmptyView()
        }
    }

    private func label(_ item: SectionItem) -> some View {
        HStack {
            Circle().fill(item.accent.color).frame(width: 9, height: 9)
            Text(item.name).font(AppFont.display(15))
                .foregroundStyle(item.available ? Catppuccin.text : Catppuccin.overlay0)
            Spacer()
            if !item.available {
                Text("soon").font(AppFont.mono(10)).foregroundStyle(Catppuccin.overlay0)
            }
        }
    }
}

#Preview { HomeView() }
