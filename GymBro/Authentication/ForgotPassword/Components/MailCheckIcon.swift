import SwiftUI

/// Envelope-with-a-check glyph shown on the confirmation state.
///
/// Recreated from the prototype's inline SVG (24×24 viewBox, three stroked
/// sub-paths): the open envelope outline, the flap, and an overlaid checkmark.
/// Drawn as a single stroked `Path` scaled to the requested size so it stays
/// crisp at any dimension.
struct MailCheckIcon: View {
    var size: CGFloat = 32
    var color: Color = .volt

    var body: some View {
        MailCheckShape()
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: 1.7 * (size / 24),
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .frame(width: size, height: size)
    }
}

private struct MailCheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        let s = rect.width / 24
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s, y: y * s) }

        var path = Path()

        // Envelope outline — top-left/right and bottom-right corners rounded,
        // bottom-left left open where the checkmark sits.
        path.move(to: p(3, 6.5))
        path.addQuadCurve(to: p(4.5, 5), control: p(3, 5))
        path.addLine(to: p(19.5, 5))
        path.addQuadCurve(to: p(21, 6.5), control: p(21, 5))
        path.addLine(to: p(21, 13.5))
        path.addQuadCurve(to: p(19.5, 15), control: p(21, 15))
        path.addLine(to: p(10, 15))

        // Flap.
        path.move(to: p(3.4, 6.2))
        path.addLine(to: p(12, 12.2))
        path.addLine(to: p(16.6, 9))

        // Checkmark.
        path.move(to: p(4, 19))
        path.addLine(to: p(6.4, 21.4))
        path.addLine(to: p(11, 16.5))

        return path
    }
}

// MARK: - Preview

#Preview {
    MailCheckIcon(size: 64)
        .padding(40)
        .background(.appBackground)
}
