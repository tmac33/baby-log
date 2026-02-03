import SwiftUI
import Charts



enum TimeRange: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
}

struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}
struct ContentView: View {
    @StateObject private var store = LogStore()
    @State private var selectedRange: TimeRange = .today
    @State private var shareItem: ShareItem? = nil
    private let statsCalc = StatsCalculator()
    private let exporter = CSVExporter()
    @State private var showAddFeed = false
    @State private var showAddDiaper = false
    @State private var showVoice = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                summaryCard
                Picker("Range", selection: $selectedRange) {
                    ForEach(TimeRange.allCases, id: \.self) { r in
                        Text(r.rawValue).tag(r)
                    }
                }
                .pickerStyle(.segmented)
                dailyStatsCard
                chartsSection
                actionBar
                timelineList
            }
            .padding()
            .navigationTitle("Baby Log")
        }
        .sheet(isPresented: $showAddFeed) {
            AddFeedingView(store: store)
        }
        .sheet(isPresented: $showAddDiaper) {
            AddDiaperView(store: store)
        }
        .sheet(isPresented: $showVoice) {
            VoiceCaptureView(store: store)
        }
        .sheet(item: $shareItem) { item in
            ShareSheet(items: [item.url])
        }
    }

    
    private var filteredFeedings: [FeedingEntry] {
        filterFeedings(store.feedings, range: selectedRange)
    }

    private var filteredDiapers: [DiaperEntry] {
        filterDiapers(store.diapers, range: selectedRange)
    }

    private func filterFeedings(_ items: [FeedingEntry], range: TimeRange) -> [FeedingEntry] {
        let cal = Calendar.current
        let now = Date()
        let start: Date
        switch range {
        case .today:
            start = cal.startOfDay(for: now)
        case .week:
            start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: now))!
        case .month:
            start = cal.date(byAdding: .day, value: -29, to: cal.startOfDay(for: now))!
        }
        return items.filter { $0.time >= start }
    }

    private func filterDiapers(_ items: [DiaperEntry], range: TimeRange) -> [DiaperEntry] {
        let cal = Calendar.current
        let now = Date()
        let start: Date
        switch range {
        case .today:
            start = cal.startOfDay(for: now)
        case .week:
            start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: now))!
        case .month:
            start = cal.date(byAdding: .day, value: -29, to: cal.startOfDay(for: now))!
        }
        return items.filter { $0.time >= start }
    }

    private var feedAmountByDay: [(Date, Int)] {
        let cal = Calendar.current
        let groups = Dictionary(grouping: filteredFeedings) { cal.startOfDay(for: $0.time) }
        return groups.map { (day: $0.key, total: $0.value.reduce(0){$0+$1.amountML}) }
            .sorted { $0.day < $1.day }
    }

    private var diaperCountByDay: [(Date, Int)] {
        let cal = Calendar.current
        let groups = Dictionary(grouping: filteredDiapers) { cal.startOfDay(for: $0.time) }
        return groups.map { (day: $0.key, total: $0.value.count) }
            .sorted { $0.day < $1.day }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today Summary").font(.headline)
            HStack {
                VStack(alignment: .leading) {
                    Text("Last Feed")
                    Text(store.feedings.first.map { "\($0.amountML) ml" } ?? "-")
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Last Diaper")
                    Text(store.diapers.first?.type.rawValue.capitalized ?? "-")
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    \n    private var dailyStatsCard: some View {
        let stats = statsCalc.stats(for: Date(), feedings: filteredFeedings, diapers: filteredDiapers)
        return VStack(alignment: .leading, spacing: 6) {
            Text("Daily Summary").font(.headline)
            Text("Feeds: \(stats.totalFeeds)  |  Total: \(stats.totalAmountML) ml")
            Text("Diapers: \(stats.diaperCount) (Wet \(stats.wetCount) / Dirty \(stats.dirtyCount) / Mixed \(stats.mixedCount))")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var actionBar: some View {
        HStack {
            Button("Feed") { showAddFeed = true }
                .buttonStyle(.borderedProminent)
            Button("Diaper") { showAddDiaper = true }
                .buttonStyle(.bordered)
            Button("Voice") { showVoice = true }
                .buttonStyle(.bordered)
        }
    }

    private var timelineList: some View {
        List(store.timeline) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title).bold()
                    Text(item.subtitle).font(.subheadline)
                }
                Spacer()
                Text(item.time, style: .time).font(.caption)
            }
        }
        .listStyle(.plain)
    }
}
