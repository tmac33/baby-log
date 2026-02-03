import Foundation

struct TrendSummary {
    let feedChange: String
    let diaperChange: String
}

final class TrendCalculator {
    func compareTodayVsYesterday(feedings: [FeedingEntry], diapers: [DiaperEntry]) -> TrendSummary {
        let cal = Calendar.current
        let today = Date()
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!

        let tFeed = feedings.filter { cal.isDate($0.time, inSameDayAs: today) }.count
        let yFeed = feedings.filter { cal.isDate($0.time, inSameDayAs: yesterday) }.count
        let tDiaper = diapers.filter { cal.isDate($0.time, inSameDayAs: today) }.count
        let yDiaper = diapers.filter { cal.isDate($0.time, inSameDayAs: yesterday) }.count

        func arrow(_ now: Int, _ prev: Int) -> String {
            if now > prev { return "↑" }
            if now < prev { return "↓" }
            return "→"
        }

        return TrendSummary(feedChange: arrow(tFeed, yFeed), diaperChange: arrow(tDiaper, yDiaper))
    }
}
