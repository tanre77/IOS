import Foundation

enum PartyRepositoryError: Error, Equatable {
    case resourceMissing(String)
}

/// Loads the bundled party content.
enum PartyRepository {
    static let resourceName = "party"

    static func decode(_ data: Data) throws -> PartyEvent {
        try JSONDecoder().decode(PartyEvent.self, from: data)
    }

    static func load(from bundle: Bundle = .main) throws -> PartyEvent {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw PartyRepositoryError.resourceMissing("\(resourceName).json")
        }
        return try decode(Data(contentsOf: url))
    }
}
