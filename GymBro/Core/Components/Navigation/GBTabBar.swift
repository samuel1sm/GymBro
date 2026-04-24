import SwiftUI

// MARK: - Tab definition

enum GBTab: String, CaseIterable, Hashable {
    case home, workouts, log, stats, profile

    var icon: String {
        switch self {
        case .home:     return "house"
        case .workouts: return "dumbbell"
        case .log:      return "plus"
        case .stats:    return "chart.bar"
        case .profile:  return "person"
        }
    }

    var label: String {
        switch self {
        case .home:     return "Home"
        case .workouts: return "Workouts"
        case .log:      return ""
        case .stats:    return "Stats"
        case .profile:  return "Profile"
        }
    }
}

// MARK: - GBTabBar

struct GBTabBar: View {
    var activeTab: GBTab = .home
    var onTap: ((GBTab) -> Void)? = nil

    private let tabs = GBTab.allCases

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                if tab == .log {
                    Spacer()
                    Button { onTap?(tab) } label: {
                        GBIconButtonVolt(icon: tab.icon, size: 48)
                            .padding(.bottom, 4)
                    }
                    Spacer()
                } else {
                    Spacer()
                    Button { onTap?(tab) } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 24))
                                .foregroundStyle(activeTab == tab ? Color.volt : Color.labelTertiary)
                            if !tab.label.isEmpty {
                                Text(tab.label)
                                    .font(.micro())
                                    .kerning(0.1)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(activeTab == tab ? Color.volt : Color.labelTertiary)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .padding(.bottom, 28)
        .background(.appBackground)
        .overlay(alignment: .top) { GBDivider() }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var active: GBTab = .home
    VStack {
        Spacer()
        GBTabBar(activeTab: active, onTap: { active = $0 })
    }
    .background(.appBackground)
}
