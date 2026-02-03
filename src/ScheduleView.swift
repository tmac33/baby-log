import SwiftUI

struct ScheduleView: View {
    @ObservedObject var store: LogStore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ScheduleBoardView(store: store)
            }
            .padding()
        }
        .background(AppTheme.background)
    }
}
