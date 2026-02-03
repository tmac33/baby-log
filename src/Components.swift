import SwiftUI

struct Card<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding()
            .background(AppTheme.card)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).bold().frame(maxWidth: .infinity).padding(.vertical, 14)
        }
        .background(AppTheme.primary)
        .foregroundColor(.white)
        .cornerRadius(14)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).bold().frame(maxWidth: .infinity).padding(.vertical, 12)
        }
        .background(AppTheme.secondary.opacity(0.15))
        .foregroundColor(AppTheme.secondary)
        .cornerRadius(14)
    }
}
