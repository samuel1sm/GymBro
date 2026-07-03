import SwiftUI

/// Cancel · "Edit Workout" · Save nav bar heading the workout editor.
struct EditWorkoutNavBar: View {
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        HStack {
            Button(action: onCancel) {
                Text("Cancel")
                    .font(.plusJakartaSans(.medium, size: 15))
                    .foregroundStyle(.labelSecondary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Edit Workout")
                .font(.plusJakartaSans(.semiBold, size: 16))
                .foregroundStyle(.labelPrimary)

            Spacer()

            Button(action: onSave) {
                Text("Save")
                    .font(.plusJakartaSans(.semiBold, size: 15))
                    .foregroundStyle(.volt)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
            }
            .buttonStyle(.plain)
        }
        .frame(height: 38)
        .padding(.top, 4)
        .padding(.horizontal, 12)
        .padding(.bottom, 10)
        .background(Color.appBackground)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        EditWorkoutNavBar(onCancel: {}, onSave: {})
        Spacer()
    }
    .background(.appBackground)
}
