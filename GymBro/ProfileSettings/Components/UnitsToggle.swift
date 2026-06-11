import SwiftUI

/// Compact kg / lbs segmented toggle for the Units row.
struct UnitsToggle: View {
    @Binding var selection: WeightUnit

    private let options: [WeightUnit] = [.kg, .lbs]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                let isSelected = option == selection
                Button {
                    withAnimation(.easeInOut(duration: 0.14)) {
                        selection = option
                    }
                } label: {
                    Text(option.rawValue)
                        .font(.plusJakartaSans(.semiBold, size: 13))
                        .foregroundStyle(isSelected ? Color.labelPrimary : Color.labelSecondary)
                        .frame(minWidth: 42)
                        .padding(.horizontal, 12)
                        .frame(height: 28)
                        .background(isSelected ? Color.surfacePrimary : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.borderSubtle, lineWidth: 1)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Color.chipSurface)
        .clipShape(RoundedRectangle(cornerRadius: 9))
        .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.borderSubtle, lineWidth: 1))
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var unit: WeightUnit = .kg
    UnitsToggle(selection: $unit)
        .padding()
        .background(.appBackground)
}
