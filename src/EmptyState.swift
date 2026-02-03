import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.secondary)
            Text(title).font(.headline)
            Text(subtitle).font(.subheadline).multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action)
            }
        }
        .padding()
    }
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Baby Log").font(.largeTitle).bold()
            Text("3秒记录、1眼看懂、每天有回报感").foregroundColor(.secondary)
            Spacer()
            PrimaryButton(title: "Get Started") { dismiss() }
        }
        .padding()
    }
}
