import SwiftUI

struct SegmentedPicker: View {
    let options: [String]
    @Binding var selectedIndex: Int
    var compact: Bool = false

    private var height: CGFloat     { compact ? 30 : 40 }
    private var radius: CGFloat     { compact ? 8 : 10 }
    private var segRadius: CGFloat  { compact ? 6 : 8 }
    private var fontSize: CGFloat   { compact ? 12 : 14 }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { i in
                let active = selectedIndex == i
                Button { selectedIndex = i } label: {
                    Text(options[i])
                        .font(.system(size: fontSize, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: height)
                        .foregroundStyle(active ? Color.labelPrimary : Color.labelSecondary)
                        .background(active ? Color.surfacePrimary : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: segRadius))
                        .overlay {
                            if active {
                                RoundedRectangle(cornerRadius: segRadius)
                                    .stroke(Color.borderDefault, lineWidth: 1)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: radius))
        .overlay(RoundedRectangle(cornerRadius: radius).stroke(Color.borderDefault, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var selectedIndex = 0

    VStack(spacing: 24) {
        SegmentedPicker(options: ["kg", "lb"], selectedIndex: $selectedIndex)
        SegmentedPicker(options: ["Beginner", "Intermediate", "Advanced"], selectedIndex: $selectedIndex, compact: true)
    }
    .padding(24)
    .background(.appBackground)
}
