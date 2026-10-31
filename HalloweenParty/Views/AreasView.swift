import SwiftUI

struct AreasView: View {
    let event: PartyEvent

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(event.areas) { area in
                    NavigationLink(value: area) { AreaRow(area: area) }
                        .buttonStyle(.plain)
                }
                BrandFooter()
            }
            .padding()
        }
        .navigationTitle("Areas")
        .screenBackground()
        .partyDestinations(event)
    }
}

struct AreaRow: View {
    let area: PartyArea

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: area.symbol)
                .font(.title)
                .foregroundStyle(Theme.pumpkin)
                .frame(width: 48, height: 48)
                .background(Theme.purple.opacity(0.3), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(area.name)
                    .font(.headline)
                    .foregroundStyle(Theme.text)
                Text([area.setting.label, area.timeOfDay].compactMap { $0 }.joined(separator: " · "))
                    .font(.caption)
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

struct AreaDetailView: View {
    let event: PartyEvent
    let area: PartyArea

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(area.summary)
                    .foregroundStyle(Theme.text)

                let costumes = event.costumes(for: area)
                if !costumes.isEmpty {
                    SectionTitle("Costumes here")
                    FlowLayout(spacing: 8) {
                        ForEach(costumes) { costume in
                            NavigationLink(value: costume) { CostumeChip(costume: costume) }
                                .buttonStyle(.plain)
                        }
                    }
                }

                SectionTitle("Slides")
                ForEach(area.slideNumbers.compactMap(event.slide(number:))) { slide in
                    NavigationLink(value: slide) {
                        SlideArtwork(slide: slide, symbol: area.symbol, costumes: event.costumes(on: slide))
                    }
                    .buttonStyle(.plain)
                }
                BrandFooter()
            }
            .padding()
        }
        .navigationTitle(area.name)
        .navigationBarTitleDisplayMode(.inline)
        .screenBackground()
    }
}

#Preview {
    NavigationStack { AreasView(event: .preview) }
        .preferredColorScheme(.dark)
}
