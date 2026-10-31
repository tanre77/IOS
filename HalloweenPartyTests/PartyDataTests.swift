import XCTest
@testable import HalloweenParty

final class PartyDataTests: XCTestCase {
    private var event: PartyEvent!

    override func setUpWithError() throws {
        // Tests are hosted by the app (TEST_HOST), so Bundle.main is the app
        // bundle that contains party.json.
        event = try PartyRepository.load(from: .main)
    }

    func testDeckHasTwentySlidesInOrder() {
        XCTAssertEqual(event.slides.count, 20)
        XCTAssertEqual(event.slides.map(\.number), Array(1...20))
        XCTAssertEqual(event.slides.first?.kind, .title)
        XCTAssertEqual(event.slides.last?.kind, .closing)
    }

    func testTitleMatchesDeck() {
        XCTAssertEqual(event.displayTitle, "Halloween Party 2026")
        XCTAssertEqual(event.tagline, "Fire pit, costumes & good times")
    }

    func testSectionsCoverEverySlideExactlyOnce() {
        let covered = event.sections.flatMap(\.slideNumbers).sorted()
        XCTAssertEqual(covered, Array(1...20))
        for slide in event.slides {
            XCTAssertEqual(event.section(for: slide)?.slideNumbers.contains(slide.number), true, "slide \(slide.number)")
        }
    }

    func testAllReferencesResolve() {
        let slideNumbers = Set(event.slides.map(\.number))
        for slide in event.slides {
            XCTAssertEqual(event.costumes(on: slide).count, slide.costumeIDs.count, "slide \(slide.number)")
            if let areaID = slide.areaID { XCTAssertNotNil(event.area(id: areaID), areaID) }
        }
        for area in event.areas {
            XCTAssertEqual(event.costumes(for: area).count, area.featuredCostumeIDs.count, area.id)
            XCTAssertTrue(Set(area.slideNumbers).isSubset(of: slideNumbers), area.id)
        }
        for highlight in event.highlights {
            XCTAssertTrue(Set(highlight.slideNumbers).isSubset(of: slideNumbers), highlight.id)
        }
        for costume in event.costumes {
            XCTAssertTrue(Set(costume.slideNumbers).isSubset(of: slideNumbers), costume.id)
        }
    }

    func testExpectedCostumesAndAreas() {
        let names = Set(event.costumes.map(\.name))
        for expected in ["Cowboy", "Cow Onesie", "Gorilla", "Yellow Full-Body Suit", "Luchador", "Nun",
                         "Brown Textured Onesie", "Spider-Web Tights", "Banana", "Hot Dog"] {
            XCTAssertTrue(names.contains(expected), expected)
        }
        XCTAssertEqual(event.areas.map(\.id), ["fire-pit", "sports-bar", "golf-simulator"])
        XCTAssertEqual(event.area(id: "fire-pit")?.setting, .outdoor)
        XCTAssertEqual(event.area(id: "sports-bar")?.setting, .indoor)
    }

    func testIdentifiersAreUnique() {
        XCTAssertEqual(Set(event.costumes.map(\.id)).count, event.costumes.count)
        XCTAssertEqual(Set(event.highlights.map(\.id)).count, event.highlights.count)
        XCTAssertEqual(Set(event.areas.map(\.id)).count, event.areas.count)
        XCTAssertEqual(Set(event.sections.map(\.id)).count, event.sections.count)
    }

    func testSlideDecodingDefaultsOptionalFields() throws {
        let json = #"{"number": 1, "kind": "title", "caption": "Hi", "sectionID": "intro"}"#
        let slide = try JSONDecoder().decode(Slide.self, from: Data(json.utf8))
        XCTAssertNil(slide.areaID)
        XCTAssertEqual(slide.costumeIDs, [])
    }

    func testUnknownSlideKindFailsToDecode() {
        let json = #"{"number": 1, "kind": "video", "caption": "Hi", "sectionID": "intro"}"#
        XCTAssertThrowsError(try JSONDecoder().decode(Slide.self, from: Data(json.utf8)))
    }

    func testRoundTripEncoding() throws {
        let data = try JSONEncoder().encode(event)
        XCTAssertEqual(try PartyRepository.decode(data), event)
    }
}
