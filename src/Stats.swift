import Foundation

struct DailyStats {
    let date: Date
    let totalFeeds: Int
    let totalAmountML: Int
    let diaperCount: Int
    let wetCount: Int
    let dirtyCount: Int
    let mixedCount: Int
}

final class StatsCalculator {
    func stats(for date: Date, feedings: [FeedingEntry], diapers: [DiaperEntry]) -> DailyStats {
        let cal = Calendar.current
        let isSameDay: (Date) -> Bool = { cal.isDate($0, inSameDayAs: date) }

        let todaysFeeds = feedings.filter { isSameDay($0.time) }
        let todaysDiapers = diapers.filter { isSameDay($0.time) }

        let totalAmount = todaysFeeds.reduce(0) { $0 + $1.amountML }
        let wet = todaysDiapers.filter { $0.type == .wet }.count
        let dirty = todaysDiapers.filter { $0.type == .dirty }.count
        let mixed = todaysDiapers.filter { $0.type == .mixed }.count

        return DailyStats(
            date: date,
            totalFeeds: todaysFeeds.count,
            totalAmountML: totalAmount,
            diaperCount: todaysDiapers.count,
            wetCount: wet,
            dirtyCount: dirty,
            mixedCount: mixed
        )
    }
}
