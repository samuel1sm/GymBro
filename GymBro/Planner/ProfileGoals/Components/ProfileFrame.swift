import SwiftUI

struct ProfileFrame<Content: View>: View {
    let step: ProfileGoalsStep
    let title: String
    let subtitle: String?
    let ctaLabel: LocalizedStringKey
    let ctaDisabled: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    let content: Content

    private var totalSteps: Int { ProfileGoalsStep.totalSteps }

    init(
        step: ProfileGoalsStep,
        title: String,
        subtitle: String? = nil,
        ctaLabel: LocalizedStringKey = "Continue",
        ctaDisabled: Bool = false,
        onNext: @escaping () -> Void,
        onBack: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.step = step
        self.title = title
        self.subtitle = subtitle
        self.ctaLabel = ctaLabel
        self.ctaDisabled = ctaDisabled
        self.onNext = onNext
        self.onBack = onBack
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.labelPrimary)
                        .padding(8)
                }
                .padding(.leading, 12)

                Spacer()

                HStack(spacing: 2) {
                    Text("Step")
                    Text("\(step.rawValue)").foregroundStyle(.volt)
                    Text("/ \(totalSteps)")
                }
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.6)
                .foregroundStyle(.labelSecondary)

                Spacer()

                Color.clear.frame(width: 44)
            }
            .frame(height: 44)

            HStack(spacing: 6) {
                ForEach(0..<totalSteps, id: \.self) { i in
                    Capsule()
                        .fill(i < step.rawValue ? Color.volt : Color.loaderTrack)
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.barlowCondensed(.bold, size: 28))
                    .foregroundStyle(.labelPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.plusJakartaSans(.medium, size: 14))
                        .foregroundStyle(.labelSecondary)
                        .lineSpacing(4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)

            ScrollView {
                content
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)

            Rectangle()
                .fill(Color.borderDefault)
                .frame(height: 1)

            GBButton(
                label: ctaLabel,
                variant: .primary,
                size: .lg,
                iconRight: "chevron.right",
                isFullWidth: true,
                isDisabled: ctaDisabled
            ) {
                onNext()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(.appBackground)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ProfileFrame(
        step: .fitnessLevel,
        title: "What's your fitness goal?",
        subtitle: "Help us personalize your experience by selecting your primary fitness objective.",
        ctaLabel: "Continue",
        ctaDisabled: false,
        onNext: {
            print("Next tapped")
        },
        onBack: {
            print("Back tapped")
        }
    ) {
        VStack(spacing: 16) {
            ForEach(0..<3) { index in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Option \(index + 1)")
                        .font(.system(size: 16, weight: .semibold))
                    Text("This is a sample description for option \(index + 1)")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
}
