import SwiftUI

// MARK: - Tone

enum GBBadgeTone {
    case `default`, accent, success, warning, error, info

    var backgroundColor: Color {
        switch self {
        case .default: return .chipSurface
        case .accent:  return .voltDim
        case .success: return .chipSuccessSurface
        case .warning: return .chipWarningSurface
        case .error:   return .dangerSurface
        case .info:    return .chipInfoSurface
        }
    }

    var foregroundColor: Color {
        switch self {
        case .default: return .labelSecondary
        case .accent:  return .volt
        case .success: return .chipSuccess
        case .warning: return .flame
        case .error:   return .danger
        case .info:    return .chipInfo
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
