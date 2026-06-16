import SwiftUI

/// Clipboard-with-a-check glyph shown in the plan chip's icon tile.
///
/// Recreated from the prototype's inline SVG (24×24 viewBox, three stroked
/// sub-paths): the clip at the top, the board outline, and an overlaid
/// checkmark. Drawn as a single stroked `Path` scaled to the requested size so
/// it stays crisp at any dimension.
struct ClipboardCheckIcon: View {
    var size: CGFloat = 20
    var color: Color = .volt

    var body: some View {
        ClipboardCheckShape()
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: 1.8 * (size / 24),
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .frame(width: size, height: size)
    }
}

private struct ClipboardCheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        let s = rect.width / 24
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s, y: y * s) }

        var path = Path()

        // Clip — rounded tab across the top of the board.
        path.move(to: p(9, 4))
        path.addLine(to: p(15, 4))
        path.addQuadCurve(to: p(16, 5), control: p(16, 4))
        path.addLine(to: p(16, 6))
        path.addQuadCurve(to: p(15, 7), control: p(16, 7))
        path.addLine(to: p(9, 7))
        path.addQuadCurve(to: p(8, 6), control: p(8, 7))
        path.addLine(to: p(8, 5))
        path.addQuadCurve(to: p(9, 4), control: p(8, 4))

        // Board outline — open at the top where the clip overlaps.
        path.move(to: p(8, 5))
        path.addLine(to: p(6, 5))
        path.addQuadCurve(to: p(4, 7), control: p(4, 5))
        path.addLine(to: p(4, 19))
        path.addQuadCurve(to: p(6, 21), control: p(4, 21))
        path.addLine(to: p(18, 21))
        path.addQuadCurve(to: p(20, 19), control: p(20, 21))
        path.addLine(to: p(20, 7))
        path.addQuadCurve(to: p(18, 5), control: p(20, 5))
        path.addLine(to: p(16, 5))

        // Checkmark.
        path.move(to: p(9, 13.5))
        path.addLine(to: p(11, 15.5))
        path.addLine(to: p(15, 11))

        return path
    }
}

// MARK: - Preview

#Preview {
    ClipboardCheckIcon(size: 64)
        .padding(40)
        .background(.appBackground)
}
