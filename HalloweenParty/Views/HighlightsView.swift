import SwiftUI

struct HighlightsView: View {
    let event: PartyEvent

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(event.highlights) { highlight in
                    NavigationLink(value: highlight) { HighlightRow(highlight: highlight) }
                        .buttonStyle(.plain)
                }
                BrandFooter()
            }
            .padding()
        }
        .navigationTitle("Highlights")
        .screenBackground()
        .partyDestinations(event)
    }
}

struct HighlightRow: View {
    let highlight: Highlight

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: highlight.symbol)
                .font(.title2)
                .foregroundStyle(Theme.pumpkin)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(highlight.title)
                    .font(.headline)
                    .foregroundStyle(Theme.text)
                Text(highlight.detail)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(Theme.secondaryText)
        }
        .card()
    }
}

struct HighlightDetailView: View {
    let event: PartyEvent
    let highlight: Highlight

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(highlight.detail)
                    .font(.body)
                    .foregroundStyle(Theme.text)
                SectionTitle("From the deck")
                ForEach(highlight.slideNumbers.compactMap(event.slide(number:))) { slide in
                    NavigationLink(value: slide) {
                        SlideArtwork(
                            slide: slide,
                            symbol: highlight.symbol,
                            costumes: event.costumes(on: slide)
                        )
                    }
                    .buttonStyle(.plain)
                }
                BrandFooter()
            }
            .padding()
        }
        .navigationTitle(highlight.title)
        .navigationBarTitleDisplayMode(.inline)
        .screenBackground()
    }
}

#Preview {
    NavigationStack { HighlightsView(event: .preview) }
        .preferredColorScheme(.dark)
}
