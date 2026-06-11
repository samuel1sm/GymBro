import SwiftUI

/// iOS-style switch — volt track with dark knob when on,
/// chip-surface track with muted knob when off.
struct GBSwitch: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.18)) {
                isOn.toggle()
            }
        } label: {
            Capsule()
                .fill(isOn ? Color.volt : Color.chipSurface)
                .frame(width: 50, height: 30)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle()
                        .fill(isOn ? Color.labelOnAccent : Color.labelMuted)
                        .frame(width: 26, height: 26)
                        .shadow(color: .black.opacity(0.4), radius: 1, y: 1)
                        .padding(2)
                }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var on = true
    @Previewable @State var off = false
    HStack(spacing: 16) {
        GBSwitch(isOn: $on)
        GBSwitch(isOn: $off)
    }
    .padding()
    .background(.appBackground)
}
