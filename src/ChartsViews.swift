import SwiftUI
import Charts

struct FeedAmountChart: View {
    let data: [(Date, Int)]
    var body: some View {
        Chart(data, id: \.0) { day, total in
            BarMark(x: .value("Day", day, unit: .day), y: .value("Total ml", total))
        }
        .frame(height: 160)
    }
}

struct DiaperCountChart: View {
    let data: [(Date, Int)]
    var body: some View {
        Chart(data, id: \.0) { day, count in
            BarMark(x: .value("Day", day, unit: .day), y: .value("Diapers", count))
        }
        .frame(height: 160)
    }
}
