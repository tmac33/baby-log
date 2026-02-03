import SwiftUI

struct GrowthView: View {
    @ObservedObject var store: LogStore
    @Binding var selectedSex: Sex

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                GrowthBoardView(store: store, sex: selectedSex)
                MilestonesView(store: store)
            }
            .padding()
        }
        .background(AppTheme.background)
    }
}
