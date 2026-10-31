import SwiftUI

/// Dark Halloween backdrop used by every screen.
struct ScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(Theme.background.ignoresSafeArea())
            .toolbarBackground(Theme.background, for: .navigationBar, .tabBar)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
    }
}

extension View {
    func screenBackground() -> some View { modifier(ScreenBackground()) }

    func card() -> some View {
        padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

/// Subtle brand credit shown at the bottom of scrolling screens.
struct BrandFooter: View {
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "moon.stars")
                .foregroundStyle(Theme.purple)
            Text(Theme.brandCredit)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .accessibilityElement(children: .combine)
    }
}

struct SectionTitle: View {
    let text: String

    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text.uppercased())
            .font(.caption.weight(.bold))
            .tracking(1.2)
            .foregroundStyle(Theme.pumpkin)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Stand-in artwork for a slide. The deck's photos are not bundled
/// because this repository is public; each slide gets a themed gradient
/// with its area symbol and caption instead.
struct SlideArtwork: View {
    let slide: Slide
    let symbol: String
    var costumes: [Costume] = []

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Theme.heroGradient
            Image(systemName: symbol)
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(Theme.pumpkin.opacity(0.85))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(alignment: .leading, spacing: 6) {
                if !costumes.isEmpty {
                    Text(costumes.map(\.emoji).joined(separator: " "))
                        .font(.title3)
                }
                Text(slide.caption)
                    .font(.headline)
                    .foregroundStyle(Theme.text)
                    .multilineTextAlignment(.leading)
                Text("Slide \(slide.number)")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
            }
            .padding()
        }
        .aspectRatio(16.0 / 9.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

struct CostumeChip: View {
    let costume: Costume

    var body: some View {
        HStack(spacing: 6) {
            Text(costume.emoji)
            Text(costume.name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Theme.text)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Theme.purple.opacity(0.35), in: Capsule())
    }
}

/// Simple wrapping layout for chips.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(width: proposal.width ?? .infinity, subviews: subviews)
        let height = rows.map(\.height).reduce(0, +) + spacing * CGFloat(max(rows.count - 1, 0))
        let width = rows.map(\.width).max() ?? 0
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(width: bounds.width, subviews: subviews) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(width: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var current = Row()
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let needed = current.indices.isEmpty ? size.width : current.width + spacing + size.width
            if needed > width, !current.indices.isEmpty {
                rows.append(current)
                current = Row()
            }
            current.width = current.indices.isEmpty ? size.width : current.width + spacing + size.width
            current.height = max(current.height, size.height)
            current.indices.append(index)
        }
        if !current.indices.isEmpty { rows.append(current) }
        return rows
    }
}
