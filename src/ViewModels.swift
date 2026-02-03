import Foundation
import Combine

final class LogStore: ObservableObject {
    @Published var feedings: [FeedingEntry] = []
    @Published var diapers: [DiaperEntry] = []

    func addFeeding(amount: Int, time: Date = Date(), note: String? = nil) {
        let entry = FeedingEntry(id: UUID(), time: time, amountML: amount, note: note)
        feedings.insert(entry, at: 0)
    }

    func addDiaper(type: DiaperType, time: Date = Date(), note: String? = nil) {
        let entry = DiaperEntry(id: UUID(), time: time, type: type, note: note)
        diapers.insert(entry, at: 0)
    }

    var timeline: [TimelineItem] {
        let f = feedings.map { TimelineItem(id: $0.id, type: .feeding, time: $0.time, title: "喂奶", subtitle: "\($0.amountML) ml") }
        let d = diapers.map { TimelineItem(id: $0.id, type: .diaper, time: $0.time, title: "换尿布", subtitle: $0.type.rawValue.capitalized) }
        return (f + d).sorted { $0.time > $1.time }
    }
}
