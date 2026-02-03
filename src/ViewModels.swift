import Foundation
import Combine

final class LogStore: ObservableObject {
    @Published var babies: [Baby] = [Baby(id: UUID(), name: "Baby") ]
    @Published var selectedBabyId: UUID?
    @Published var feedings: [FeedingEntry] = []
    @Published var diapers: [DiaperEntry] = []
    @Published var growthEntries: [GrowthEntry] = []

    init() {
        selectedBabyId = babies.first?.id
        load()
    }

    func addFeeding(amount: Int, time: Date = Date(), note: String? = nil) {
        guard let babyId = selectedBabyId else { return }
        let entry = FeedingEntry(id: UUID(), babyId: babyId, time: time, amountML: amount, note: note)
        feedings.insert(entry, at: 0)
        Persistence.shared.saveFeedings(feedings)
    }

    func addDiaper(type: DiaperType, time: Date = Date(), note: String? = nil) {
        guard let babyId = selectedBabyId else { return }
        let entry = DiaperEntry(id: UUID(), babyId: babyId, time: time, type: type, note: note)
        diapers.insert(entry, at: 0)
        Persistence.shared.saveDiapers(diapers)
    }

    func addGrowth(heightCM: Double, weightKG: Double, headCM: Double, time: Date = Date()) {
        guard let babyId = selectedBabyId else { return }
        let entry = GrowthEntry(id: UUID(), babyId: babyId, time: time, heightCM: heightCM, weightKG: weightKG, headCircumferenceCM: headCM)
        growthEntries.insert(entry, at: 0)
        Persistence.shared.saveGrowth(growthEntries)
    }


    private func load() {
        feedings = Persistence.shared.loadFeedings()
        diapers = Persistence.shared.loadDiapers()
        growthEntries = Persistence.shared.loadGrowth()
    }

    var currentFeedings: [FeedingEntry] {
        guard let id = selectedBabyId else { return [] }
        return feedings.filter { $0.babyId == id }
    }

    var currentDiapers: [DiaperEntry] {
        guard let id = selectedBabyId else { return [] }
        return diapers.filter { $0.babyId == id }
    }

    var currentGrowth: [GrowthEntry] {
        guard let id = selectedBabyId else { return [] }
        return growthEntries.filter { $0.babyId == id }.sorted { $0.time < $1.time }
    }

    var timeline: [TimelineItem] {
        let f = currentFeedings.map { TimelineItem(id: $0.id, type: .feeding, time: $0.time, title: "喂奶", subtitle: "\($0.amountML) ml") }
        let d = currentDiapers.map { TimelineItem(id: $0.id, type: .diaper, time: $0.time, title: "换尿布", subtitle: $0.type.rawValue.capitalized) }
        return (f + d).sorted { $0.time > $1.time }
    }
}
