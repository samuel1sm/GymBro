import SwiftUI

/// Bottom sheet to change the session's training focus.
struct FocusPickerSheet: View {
    let options: [String]
    let current: String
    var onPick: (String) -> Void

    /// Measured content height, used to fit the sheet's detent to its content.
    @State private var contentHeight: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("SESSION FOCUS")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.6)
                .foregroundStyle(.labelTertiary)
                .padding(.horizontal, 20)
                .padding(.bottom, 14)
				.padding(.top, 20)
			
            VStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    optionRow(option)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 8)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SheetContentHeightKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(SheetContentHeightKey.self) { contentHeight = $0 }
        .presentationDetents([.height(max(contentHeight, 1))])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
        .presentationBackground(Color.appBackground)
    }

    private func optionRow(_ option: String) -> some View {
        let isSelected = option == current
        return Button {
            onPick(option)
        } label: {
            HStack {
                Text(option)
                    .font(.plusJakartaSans(.semiBold, size: 16))
                    .foregroundStyle(isSelected ? .volt : .labelPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.volt)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(isSelected ? Color.planTileBackground : Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.planChipBorder : Color.borderSubtle, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Height measurement

private struct SheetContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    Color.appBackground
        .sheet(isPresented: .constant(true)) {
            FocusPickerSheet(options: EditWorkoutState.focusOptions, current: "Push", onPick: { _ in })
        }
}
