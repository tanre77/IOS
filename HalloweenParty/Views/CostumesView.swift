import SwiftUI

struct CostumesView: View {
    let event: PartyEvent

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 12)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(event.costumes) { costume in
                    NavigationLink(value: costume) { CostumeTile(costume: costume) }
                        .buttonStyle(.plain)
                }
            }
            .padding()
            BrandFooter()
        }
        .navigationTitle("Costumes")
        .screenBackground()
        .partyDestinations(event)
    }
}

private struct CostumeTile: View {
    let costume: Costume

    var body: some View {
        VStack(spacing: 10) {
            Text(costume.emoji)
                .font(.system(size: 52))
            Text(costume.name)
                .font(.headline)
                .foregroundStyle(Theme.text)
                .multilineTextAlignment(.center)
                .lineLimit(2, reservesSpace: true)
            Text(costume.slideNumbers.isEmpty ? "Organizer's list" : "\(costume.slideNumbers.count) slide\(costume.slideNumbers.count == 1 ? "" : "s")")
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Theme.purple.opacity(0.5), lineWidth: 1)
                )
        )
        .accessibilityElement(children: .combine)
    }
}

struct CostumeDetailView: View {
    let event: PartyEvent
    let costume: Costume

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(spacing: 8) {
                    Text(costume.emoji).font(.system(size: 96))
                    Text(costume.name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.text)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: 24, style: .continuous))

                Text(costume.detail)
                    .foregroundStyle(Theme.text)

                if costume.source == .organizerNotes {
                    Label("From the organizer's costume list — not named in a deck caption.", systemImage: "info.circle")
                        .font(.footnote)
                        .foregroundStyle(Theme.secondaryText)
                }

                let slides = event.slides(for: costume)
                if !slides.isEmpty {
                    SectionTitle("Spotted on")
                    ForEach(slides) { slide in
                        NavigationLink(value: slide) {
                            SlideArtwork(
                                slide: slide,
                                symbol: slide.areaID.flatMap(event.area(id:))?.symbol ?? "sparkles",
                                costumes: event.costumes(on: slide)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                BrandFooter()
            }
            .padding()
        }
        .navigationTitle(costume.name)
        .navigationBarTitleDisplayMode(.inline)
        .screenBackground()
    }
}

#Preview {
    NavigationStack { CostumesView(event: .preview) }
        .preferredColorScheme(.dark)
}
