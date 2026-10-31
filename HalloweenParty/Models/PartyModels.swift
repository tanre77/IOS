import Foundation

/// Root of the party content. Mirrors `Resources/party.json`, which is
/// transcribed from the "Halloween Party 2026" deck (20 slides).
struct PartyEvent: Codable, Equatable {
    let title: String
    let year: Int
    let tagline: String
    let closingTitle: String
    let closingSubtitle: String
    let sections: [DeckSection]
    let slides: [Slide]
    let highlights: [Highlight]
    let costumes: [Costume]
    let areas: [PartyArea]
}

/// A group of consecutive slides in the deck (e.g. "Fire Pit Night").
struct DeckSection: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let slideNumbers: [Int]
}

/// One slide from the deck. Photo slides keep only their caption: the
/// original photos are intentionally not bundled (public repo).
struct Slide: Codable, Identifiable, Hashable {
    enum Kind: String, Codable {
        case title
        case photo
        case closing
    }

    let number: Int
    let kind: Kind
    let caption: String
    let sectionID: String
    let areaID: String?
    let costumeIDs: [String]

    var id: Int { number }

    enum CodingKeys: String, CodingKey {
        case number, kind, caption, sectionID, areaID, costumeIDs
    }

    init(number: Int, kind: Kind, caption: String, sectionID: String, areaID: String? = nil, costumeIDs: [String] = []) {
        self.number = number
        self.kind = kind
        self.caption = caption
        self.sectionID = sectionID
        self.areaID = areaID
        self.costumeIDs = costumeIDs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(Int.self, forKey: .number)
        kind = try container.decode(Kind.self, forKey: .kind)
        caption = try container.decode(String.self, forKey: .caption)
        sectionID = try container.decode(String.self, forKey: .sectionID)
        areaID = try container.decodeIfPresent(String.self, forKey: .areaID)
        costumeIDs = try container.decodeIfPresent([String].self, forKey: .costumeIDs) ?? []
    }
}

struct Highlight: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
    let symbol: String
    let slideNumbers: [Int]
}

struct Costume: Codable, Identifiable, Hashable {
    /// Where a fact came from, so the UI can be honest about it.
    enum Source: String, Codable {
        /// Named in a deck caption.
        case deck
        /// From the organizer's costume list, not a deck caption.
        case organizerNotes
    }

    let id: String
    let name: String
    let emoji: String
    let detail: String
    let source: Source
    let slideNumbers: [Int]
}

struct PartyArea: Codable, Identifiable, Hashable {
    enum Setting: String, Codable {
        case indoor
        case outdoor

        var label: String { rawValue.capitalized }
    }

    let id: String
    let name: String
    let setting: Setting
    let timeOfDay: String?
    let symbol: String
    let summary: String
    let slideNumbers: [Int]
    let featuredCostumeIDs: [String]
}

// MARK: - Lookups

extension PartyEvent {
    var displayTitle: String { "\(title) \(year)" }

    func slide(number: Int) -> Slide? {
        slides.first { $0.number == number }
    }

    func slides(in section: DeckSection) -> [Slide] {
        section.slideNumbers.compactMap(slide(number:))
    }

    func section(for slide: Slide) -> DeckSection? {
        sections.first { $0.id == slide.sectionID }
    }

    func costume(id: String) -> Costume? {
        costumes.first { $0.id == id }
    }

    func area(id: String) -> PartyArea? {
        areas.first { $0.id == id }
    }

    func costumes(for area: PartyArea) -> [Costume] {
        area.featuredCostumeIDs.compactMap(costume(id:))
    }

    func costumes(on slide: Slide) -> [Costume] {
        slide.costumeIDs.compactMap(costume(id:))
    }

    func slides(for costume: Costume) -> [Slide] {
        costume.slideNumbers.compactMap(slide(number:))
    }
}
