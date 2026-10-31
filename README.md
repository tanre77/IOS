# Halloween Party 2026 — iOS

A SwiftUI app for the **Halloween Party 2026** event: *Fire pit, costumes & good times.*
Its content comes from the "Halloween Party 2026" deck (20 slides), turned into
browsable screens: highlights, a costume gallery, the party areas (fire pit, sports bar,
golf simulator) and a slide-by-slide deck view.

Built by Tanner Hughes · TJH Ventures LLC.

> **Privacy note:** this repository is public, so the deck's photos are **not** included.
> Slides show themed artwork (gradient + SF Symbol + caption) instead of the original photos.

## Requirements

- Xcode 15 or later (Swift 5.9+), iOS 17.0+ deployment target
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

## Build & run

```bash
brew install xcodegen      # once
xcodegen generate          # creates HalloweenParty.xcodeproj from project.yml
open HalloweenParty.xcodeproj
```

Choose the **HalloweenParty** scheme and an iPhone simulator, then press ⌘R. To run on a
device, set your signing team in the target's *Signing & Capabilities* tab.

Command line:

```bash
xcodegen generate
xcodebuild build -scheme HalloweenParty -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO
xcodebuild test  -scheme HalloweenParty -destination 'platform=iOS Simulator,name=iPhone 15'
```

The `.xcodeproj` is generated and git-ignored; `project.yml` is the source of truth, so
there is no `.pbxproj` to hand-merge.

## Structure

```
project.yml                       XcodeGen spec (app + unit-test targets, iOS 17)
HalloweenParty/
  App/HalloweenPartyApp.swift     @main entry, loads party.json, dark theme
  Models/PartyModels.swift        PartyEvent, DeckSection, Slide, Highlight, Costume, PartyArea + lookups
  Models/PartyRepository.swift    JSON loading/decoding
  Models/PartyEvent+Preview.swift Preview data
  Resources/party.json            Deck content (single source of truth for the UI)
  Resources/Assets.xcassets       Accent color (deck orange #E25B2A)
  Theme/Theme.swift               Palette from the deck + Halloween purple, brand credit
  Views/                          Root tabs, Home, Highlights, Costumes, Areas, Deck, shared components
HalloweenPartyTests/
  PartyDataTests.swift            Decoding + data-integrity tests
.github/workflows/ios-build.yml   CI: xcodegen + xcodebuild build/test on macos-latest
```

### Screens

| Tab | What it shows |
| --- | --- |
| **Home** | Title/year/tagline hero, counts, the three areas, top highlights |
| **Highlights** | Seven moments from the deck; each opens the slides it came from |
| **Costumes** | Grid of 10 costumes → detail with the slides they appear on |
| **Areas** | Fire Pit (outdoor, night), Sports Bar (indoor), Golf Simulator (indoor) |
| **Deck** | All 20 slides grouped into sections; tap to swipe through them |

### Content

`party.json` holds everything shown in the app. Slide captions are copied verbatim from the
deck. Costumes carry a `source` of `deck` (named in a caption) or `organizerNotes` (from the
organizer's costume list, e.g. *Brown Textured Onesie*, *Spider-Web Tights*). No dates,
addresses, or guest names are included.

Placeholders: the bundle identifier `com.tjhventures.halloweenparty2026` and version `0.1.0`
are placeholders; change them in `project.yml` before shipping.

## Next steps

- Add an app icon and a branded launch screen (Halloween palette + TJH Ventures mark).
- Optionally add privacy-safe artwork per slide (illustrations, or photos only with
  everyone's consent, ideally loaded from a private source rather than this public repo).
- Event info (date, time, RSVP) once the organizer provides it.
