import Foundation

extension PartyEvent {
    /// Bundled content for SwiftUI previews. Falls back to a tiny sample
    /// if the JSON resource is unavailable in the preview process.
    static var preview: PartyEvent {
        if let event = try? PartyRepository.load() { return event }
        let slide = Slide(number: 1, kind: .title, caption: "Halloween Party 2026", sectionID: "intro")
        return PartyEvent(
            title: "Halloween Party",
            year: 2026,
            tagline: "Fire pit, costumes & good times",
            closingTitle: "Halloween 2026",
            closingSubtitle: "Added to the archive ✓",
            sections: [DeckSection(id: "intro", title: "Halloween Party 2026", subtitle: "Title", symbol: "moon.stars.fill", slideNumbers: [1])],
            slides: [slide],
            highlights: [],
            costumes: [],
            areas: []
        )
    }
}
