import SwiftUI

struct MainTabView: View {
    @StateObject private var store = LogStore()
    @State private var showOnboarding: Bool = true
    @State private var selectedSex: Sex = .male

    var body: some View {
        TabView {
            TodayView(store: store, selectedSex: $selectedSex)
                .tabItem { Label("Today", systemImage: "house") }

            GrowthView(store: store, selectedSex: $selectedSex)
                .tabItem { Label("Growth", systemImage: "chart.line.uptrend.xyaxis") }

            ScheduleView(store: store)
                .tabItem { Label("Schedule", systemImage: "calendar") }
        }
        .sheet(isPresented: $showOnboarding) { OnboardingView() }
    }
}
