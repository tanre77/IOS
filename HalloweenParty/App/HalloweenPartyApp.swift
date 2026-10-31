import SwiftUI

@main
struct HalloweenPartyApp: App {
    private let loadResult: Result<PartyEvent, Error> = Result { try PartyRepository.load() }

    var body: some Scene {
        WindowGroup {
            Group {
                switch loadResult {
                case .success(let event):
                    RootView(event: event)
                case .failure(let error):
                    ContentUnavailableView(
                        "Couldn't load the party",
                        systemImage: "exclamationmark.triangle",
                        description: Text(String(describing: error))
                    )
                }
            }
            .preferredColorScheme(.dark)
            .tint(Theme.pumpkin)
        }
    }
}
