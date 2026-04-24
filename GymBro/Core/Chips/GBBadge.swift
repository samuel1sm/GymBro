import SwiftUI

// MARK: - Tone

enum GBBadgeTone {
    case `default`, accent, success, warning, error, info

    var backgroundColor: Color {
        switch self {
        case .default: return Color(red: 0.18, green: 0.18, blue: 0.18)
        case .accent:  return .voltDim
        case .success: return Color(red: 0.298, green: 0.686, blue: 0.314, opacity: 0.15)
        case .warning: return Color(red: 1.0, green: 0.757, blue: 0.027, opacity: 0.15)
        case .error:   return .dangerSurface
        case .info:    return Color(red: 0.129, green: 0.588, blue: 0.953, opacity: 0.15)
        }
    }

    var foregroundColor: Color {
        switch self {
        case .default: return .labelSecondary
        case .accent:  return .volt
        case .success: return Color(red: 0.298, green: 0.686, blue: 0.314)
        case .warning: return .flame
        case .error:   return .danger
        case .info:    return Color(red: 0.129, green: 0.588, blue: 0.953)
        }
    }
}

// MARK: - GBBadge

struct GBBadge: View {
    var label: String
    var tone: GBBadgeTone = .default

    var body: some View {
        Text(label.uppercased())
            .font(.micro())
            .kerning(0.6)
            .foregroundStyle(tone.foregroundColor)
            .frame(height: 22)
            .padding(.horizontal, 8)
            .background(tone.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 8) {
        GBBadge(label: "Draft")
        GBBadge(label: "PR",     tone: .accent)
        GBBadge(label: "Done",   tone: .success)
        GBBadge(label: "Missed", tone: .warning)
        GBBadge(label: "Failed", tone: .error)
        GBBadge(label: "Synced", tone: .info)
    }
    .padding()
    .background(.appBackground)
}
