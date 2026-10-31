import SwiftUI

/// Slide-by-slide view of the deck, grouped by section.
struct DeckView: View {
    let event: PartyEvent

    var body: some View {
        List {
            ForEach(event.sections) { section in
                Section {
                    ForEach(event.slides(in: section)) { slide in
                        NavigationLink(value: slide) {
                            HStack(spacing: 12) {
                                Text("\(slide.number)")
                                    .font(.caption.monospacedDigit().bold())
                                    .foregroundStyle(Theme.pumpkin)
                                    .frame(width: 28)
                                Text(slide.caption)
                                    .foregroundStyle(Theme.text)
                            }
                        }
                        .listRowBackground(Theme.surface)
                    }
                } header: {
                    Label(section.title, systemImage: section.symbol)
                        .foregroundStyle(Theme.pumpkin)
                }
            }
            Section {
                BrandFooter()
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Deck")
        .screenBackground()
        .partyDestinations(event)
    }
}

/// Swipe through the deck one slide at a time.
struct SlidePagerView: View {
    let event: PartyEvent
    @State private var selection: Int

    init(event: PartyEvent, startAt number: Int) {
        self.event = event
        _selection = State(initialValue: number)
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(event.slides) { slide in
                SlidePage(event: event, slide: slide)
                    .tag(slide.number)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .navigationTitle("Slide \(selection) of \(event.slides.count)")
        .navigationBarTitleDisplayMode(.inline)
        .screenBackground()
    }
}

private struct SlidePage: View {
    let event: PartyEvent
    let slide: Slide

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            switch slide.kind {
            case .title:
                VStack(spacing: 8) {
                    Text(event.title).font(.system(size: 44, weight: .heavy)).foregroundStyle(Theme.text)
                    Text(String(event.year)).font(.system(size: 36, weight: .heavy)).foregroundStyle(Theme.pumpkin)
                    Text(event.tagline).font(.title3).foregroundStyle(Theme.secondaryText)
                }
                .multilineTextAlignment(.center)
            case .closing:
                VStack(spacing: 8) {
                    Text(event.closingTitle).font(.system(size: 36, weight: .heavy)).foregroundStyle(Theme.pumpkin)
                    Text(event.closingSubtitle).font(.title3).foregroundStyle(Theme.text)
                }
                .multilineTextAlignment(.center)
            case .photo:
                SlideArtwork(
                    slide: slide,
                    symbol: slide.areaID.flatMap(event.area(id:))?.symbol ?? "camera.fill",
                    costumes: event.costumes(on: slide)
                )
                if let section = event.section(for: slide) {
                    Label(section.title, systemImage: section.symbol)
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                }
            }
            Spacer()
            Text(Theme.brandCredit)
                .font(.caption2)
                .foregroundStyle(Theme.secondaryText)
                .padding(.bottom, 40)
        }
        .padding()
    }
}

#Preview {
    NavigationStack { DeckView(event: .preview) }
        .preferredColorScheme(.dark)
}
