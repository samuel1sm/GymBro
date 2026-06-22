import SwiftUI

/// Small squared chip used inside the editor's exercise cards to show
/// `sets × reps` and `rest` — flat surface, no border, 7pt radius.
struct EditSpecChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.plusJakartaSans(.semiBold, size: 12))
            .kerning(-0.1)
            .foregroundStyle(.labelSecondary)
            .lineLimit(1)
            .frame(height: 24)
            .padding(.horizontal, 9)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

#Preview {
    HStack(spacing: 6) {
        EditSpecChip(text: "4 × 6–8")
        EditSpecChip(text: "120s rest")
    }
    .padding()
    .background(.appBackground)
}
