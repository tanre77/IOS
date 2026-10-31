import SwiftUI

struct HomeView: View {
    let event: PartyEvent

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero
                stats

                SectionTitle("Where it happened")
                VStack(spacing: 12) {
                    ForEach(event.areas) { area in
                        NavigationLink(value: area) { AreaRow(area: area) }
                            .buttonStyle(.plain)
                    }
                }

                SectionTitle("Highlights")
                VStack(spacing: 12) {
                    ForEach(event.highlights.prefix(3)) { highlight in
                        NavigationLink(value: highlight) { HighlightRow(highlight: highlight) }
                            .buttonStyle(.plain)
                    }
                }

                BrandFooter()
            }
            .padding()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .screenBackground()
        .partyDestinations(event)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.system(size: 40, weight: .heavy))
                .foregroundStyle(Theme.text)
            Text(String(event.year))
                .font(.system(size: 34, weight: .heavy))
                .foregroundStyle(Theme.pumpkin)
            Text(event.tagline)
                .font(.title3)
                .foregroundStyle(Theme.secondaryText)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private var stats: some View {
        HStack(spacing: 12) {
            StatTile(value: event.slides.count, label: "Slides", symbol: "rectangle.stack")
            StatTile(value: event.costumes.count, label: "Costumes", symbol: "theatermasks")
            StatTile(value: event.areas.count, label: "Areas", symbol: "map")
        }
    }
}

private struct StatTile: View {
    let value: Int
    let label: String
    let symbol: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: symbol).foregroundStyle(Theme.purple)
            Text("\(value)").font(.title2.bold()).foregroundStyle(Theme.text)
            Text(label).font(.caption).foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { HomeView(event: .preview) }
        .preferredColorScheme(.dark)
}
