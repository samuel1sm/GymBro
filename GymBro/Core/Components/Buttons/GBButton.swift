import SwiftUI

// MARK: - Variants & Sizes

enum GBButtonVariant {
    case primary, secondary, ghost, destruct
}

enum GBButtonSize {
    case sm, md, lg

    var height: CGFloat {
        switch self { case .sm: 36; case .md: 48; case .lg: 56 }
    }

    var horizontalPadding: CGFloat {
        switch self { case .sm: 14; case .md: 20; case .lg: 24 }
    }

    var font: Font {
        switch self {
        case .sm: .plusJakartaSans(.semiBold, size: 14)
        case .md: .plusJakartaSans(.semiBold, size: 15)
        case .lg: .plusJakartaSans(.semiBold, size: 17)
        }
    }

    var iconSize: CGFloat {
        switch self { case .sm: 14; case .md: 18; case .lg: 20 }
    }
}

// MARK: - GBButton

struct GBButton: View {
    var label: String
    var variant: GBButtonVariant = .primary
    var size: GBButtonSize = .md
    var icon: String? = nil
    var iconRight: String? = nil
    var isFullWidth: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void = {}

    private var backgroundColor: Color {
        switch variant {
        case .primary:   return .volt
        case .secondary: return .surfaceSecondary
        case .ghost:     return .clear
        case .destruct:  return .surfaceSecondary
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary:   return .labelOnAccent
        case .secondary: return .labelPrimary
        case .ghost:     return .labelPrimary
        case .destruct:  return .danger
        }
    }

    private var borderColor: Color {
        switch variant {
        case .primary:   return .clear
        case .secondary: return .borderDefault
        case .ghost:     return .clear
        case .destruct:  return .borderDefault
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize, weight: .semibold))
                }
                Text(label)
                    .font(size.font)
                if let iconRight {
                    Image(systemName: iconRight)
                        .font(.system(size: size.iconSize, weight: .semibold))
                }
            }
            .foregroundStyle(foregroundColor)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: 1))
            .opacity(isDisabled ? 0.35 : 1)
        }
        .disabled(isDisabled)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 12) {
        GBButton(label: "Start Workout", variant: .primary, size: .lg, isFullWidth: true)
        HStack(spacing: 10) {
            GBButton(label: "Begin Set", variant: .primary, size: .md, icon: "play.fill")
            GBButton(label: "Continue", variant: .primary, size: .md, iconRight: "chevron.right")
            GBButton(label: "Log", variant: .primary, size: .sm)
        }
        HStack(spacing: 10) {
            GBButton(label: "Add", variant: .secondary, size: .md, icon: "plus")
            GBButton(label: "Skip", variant: .secondary, size: .md)
            GBButton(label: "Ghost", variant: .ghost, size: .md)
        }
        GBButton(label: "End Session", variant: .destruct, size: .md, icon: "xmark")
        HStack(spacing: 10) {
            GBButton(label: "Default", variant: .primary)
            GBButton(label: "Disabled", variant: .primary, isDisabled: true)
        }
    }
    .padding()
    .background(.appBackground)
}
