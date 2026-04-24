import SwiftUI

struct GBCard<Content: View>: View {
    var elevated: Bool = false
    var padded: Bool = true
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padded ? 20 : 0)
            .background(elevated ? Color.surfaceSecondary : Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        GBCard {
            VStack(alignment: .leading, spacing: 4) {
                Text("TUE · PUSH")
                    .font(.micro())
                    .kerning(1.6)
                    .foregroundStyle(.volt)
                Text("Chest & Triceps")
                    .font(.headingSM())
                    .foregroundStyle(.labelPrimary)
                Text("6 exercises · 52 min est.")
                    .font(.bodySM())
                    .foregroundStyle(.labelSecondary)
            }
        }
        GBCard(elevated: true) {
            Text("Elevated surface (Surface2)")
                .font(.bodyMD())
                .foregroundStyle(.labelPrimary)
        }
        GBCard(padded: false) {
            HStack {
                Text("Unpadded card")
                    .font(.bodyMD())
                    .foregroundStyle(.labelPrimary)
                    .padding(20)
                Spacer()
            }
        }
    }
    .padding()
    .background(.appBackground)
}
