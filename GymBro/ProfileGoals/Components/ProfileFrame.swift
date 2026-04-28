import SwiftUI

struct ProfileFrame<Content: View>: View {
    let step: Int
    let totalSteps: Int
    let title: String
    let subtitle: String?
    let ctaLabel: LocalizedStringKey
    let ctaDisabled: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    let content: Content

    init(
        step: Int,
        totalSteps: Int = 5,
        title: String,
        subtitle: String? = nil,
        ctaLabel: LocalizedStringKey = "Continue",
        ctaDisabled: Bool = false,
        onNext: @escaping () -> Void,
        onBack: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.step = step
        self.totalSteps = totalSteps
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
                    Text("\(step)").foregroundStyle(.volt)
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
                        .fill(i < step ? Color.volt : Color.loaderTrack)
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
        .toolbar(.hidden, for: .navigationBar)
    }
}
