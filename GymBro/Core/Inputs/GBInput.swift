import SwiftUI

// Surface3 (#2E2E2E) — used for input/chip backgrounds, slightly above Surface2
private let gbSurface3 = Color(red: 0.18, green: 0.18, blue: 0.18)

struct GBInput: View {
    var label: String? = nil
    @Binding var text: String
    var placeholder: String = ""
    var icon: String? = nil
    var suffix: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let label {
                Text(label)
                    .font(.bodySM())
                    .foregroundStyle(.labelSecondary)
            }
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(.labelSecondary)
                }
                TextField(placeholder, text: $text)
                    .font(.plusJakartaSans(.regular, size: 17))
                    .foregroundStyle(.labelPrimary)
                    .tint(.volt)
                if let suffix {
                    Text(suffix)
                        .font(.bodySM())
                        .foregroundStyle(.labelSecondary)
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 14)
            .background(gbSurface3)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.borderDefault, lineWidth: 1))
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var workoutName = "Push Day — Chest & Tri"
    @Previewable @State var search = ""
    @Previewable @State var weight = "185"
    @Previewable @State var notes = ""

    VStack(spacing: 14) {
        GBInput(label: "Workout name", text: $workoutName)
        GBInput(label: "Search", text: $search, placeholder: "Search exercises…", icon: "magnifyingglass")
        GBInput(label: "Weight", text: $weight, suffix: "LB")
        GBInput(label: "Notes", text: $notes, placeholder: "Add note…")
    }
    .padding()
    .background(.appBackground)
}
