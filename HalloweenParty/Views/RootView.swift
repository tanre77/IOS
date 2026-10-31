import SwiftUI

struct RootView: View {
    let event: PartyEvent

    var body: some View {
        TabView {
            NavigationStack { HomeView(event: event) }
                .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { HighlightsView(event: event) }
                .tabItem { Label("Highlights", systemImage: "sparkles") }

            NavigationStack { CostumesView(event: event) }
                .tabItem { Label("Costumes", systemImage: "theatermasks.fill") }

            NavigationStack { AreasView(event: event) }
                .tabItem { Label("Areas", systemImage: "map.fill") }

            NavigationStack { DeckView(event: event) }
                .tabItem { Label("Deck", systemImage: "rectangle.stack.fill") }
        }
    }
}

/// Shared navigation destinations so any tab can push any detail screen.
struct PartyDestinations: ViewModifier {
    let event: PartyEvent

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Costume.self) { CostumeDetailView(event: event, costume: $0) }
            .navigationDestination(for: PartyArea.self) { AreaDetailView(event: event, area: $0) }
            .navigationDestination(for: Highlight.self) { HighlightDetailView(event: event, highlight: $0) }
            .navigationDestination(for: Slide.self) { SlidePagerView(event: event, startAt: $0.number) }
    }
}

extension View {
    func partyDestinations(_ event: PartyEvent) -> some View {
        modifier(PartyDestinations(event: event))
    }
}

#Preview {
    RootView(event: .preview)
        .preferredColorScheme(.dark)
}
