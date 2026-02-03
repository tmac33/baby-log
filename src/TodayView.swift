import SwiftUI

struct TodayView: View {
    @ObservedObject var store: LogStore
    @Binding var selectedSex: Sex
    @State private var showAddFeed = false
    @State private var showAddDiaper = false
    @State private var showVoice = false
    @State private var shareItem: ShareItem? = nil
    @State private var reminderMinutes: Double = 120
    @State private var selectedRange: TimeRange = .today
    private let statsCalc = StatsCalculator()
    private let exporter = CSVExporter()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                summaryCard
                rangePicker
                dailyStatsCard
                chartsSection
                reminderCard
                quickActions
                repeatButton
                timelineList
            }
            .padding()
        }
        .background(AppTheme.background)
        .sheet(isPresented: $showAddFeed) { AddFeedingView(store: store) }
        .sheet(isPresented: $showAddDiaper) { AddDiaperView(store: store) }
        .sheet(isPresented: $showVoice) { VoiceCaptureView(store: store) }
        .sheet(item: $shareItem) { item in ShareSheet(items: [item.url]) }
    }

    private var header: some View {
        HStack {
            Picker("Baby", selection: $store.selectedBabyId) {
                ForEach(store.babies) { b in
                    Text(b.name).tag(Optional(b.id))
                }
            }
            .pickerStyle(.menu)
            Spacer()
            Picker("Sex", selection: $selectedSex) {
                Text("Boy").tag(Sex.male)
                Text("Girl").tag(Sex.female)
            }
            .pickerStyle(.menu)
        }
    }

    private var summaryCard: some View {
        Card {
            VStack(alignment: .leading, spacing: 8) {
                Text("Today Summary").font(.headline)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Last Feed")
                        Text(store.currentFeedings.first.map { "\($0.amountML) ml" } ?? "-")
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Last Diaper")
                        Text(store.currentDiapers.first?.type.rawValue.capitalized ?? "-")
                            .font(.subheadline)
                    }
                }
            }
        }
    }

    private var rangePicker: some View {
        Picker("Range", selection: $selectedRange) {
            ForEach(TimeRange.allCases, id: \.self) { r in
                Text(r.rawValue).tag(r)
            }
        }
        .pickerStyle(.segmented)
    }

    private var dailyStatsCard: some View {
        let stats = statsCalc.stats(for: Date(), feedings: filteredFeedings, diapers: filteredDiapers)
        return Card {
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Summary").font(.headline)
                Text("Feeds: \(stats.totalFeeds)  |  Total: \(stats.totalAmountML) ml")
                Text("Diapers: \(stats.diaperCount) (Wet \(stats.wetCount) / Dirty \(stats.dirtyCount) / Mixed \(stats.mixedCount))")
            }
        }
    }

    private var chartsSection: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                Text("Charts").font(.headline)
                FeedAmountChart(data: feedAmountByDay)
                DiaperCountChart(data: diaperCountByDay)
            }
        }
    }

    private var reminderCard: some View {
        Card {
            VStack(alignment: .leading, spacing: 8) {
                Text("Reminder Interval: \(Int(reminderMinutes)) min").font(.subheadline)
                Slider(value: $reminderMinutes, in: 30...300, step: 10)
                SecondaryButton(title: "Set Reminder") {
                    NotificationManager.shared.requestPermission { ok in
                        if ok {
                            NotificationManager.shared.scheduleReminder(id: "feed-reminder", title: "Time to feed", body: "Log baby feeding", inMinutes: reminderMinutes)
                        }
                    }
                }
            }
        }
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            PrimaryButton(title: "Feed") { showAddFeed = true }
            PrimaryButton(title: "Diaper") { showAddDiaper = true }
            SecondaryButton(title: "Voice") { showVoice = true }
        }
    }

    private var repeatButton: some View {
        SecondaryButton(title: "Repeat Last Feed") {
            if let last = store.currentFeedings.first {
                store.addFeeding(amount: last.amountML, time: Date())
            }
        }
    }

    private var timelineList: some View {
        Card {
            VStack(alignment: .leading) {
                Text("Timeline").font(.headline)
                ForEach(store.timeline.prefix(8)) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title).bold()
                            Text(item.subtitle).font(.subheadline)
                        }
                        Spacer()
                        Text(item.time, style: .time).font(.caption)
                    }
                    Divider()
                }

                SecondaryButton(title: "Export CSV") {
                    if let url = exporter.export(feedings: filteredFeedings, diapers: filteredDiapers) {
                        shareItem = ShareItem(url: url)
                    }
                }
            }
        }
    }

    private var filteredFeedings: [FeedingEntry] {
        filterFeedings(store.currentFeedings, range: selectedRange)
    }

    private var filteredDiapers: [DiaperEntry] {
        filterDiapers(store.currentDiapers, range: selectedRange)
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
}
