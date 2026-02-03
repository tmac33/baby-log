import Foundation

enum EntryType: String, Codable {
    case feeding
    case diaper
}

enum DiaperType: String, Codable, CaseIterable {
    case wet
    case dirty
    case mixed
}

struct FeedingEntry: Identifiable, Codable {
    let id: UUID
    var time: Date
    var amountML: Int
    var note: String?
}

struct DiaperEntry: Identifiable, Codable {
    let id: UUID
    var time: Date
    var type: DiaperType
    var note: String?
}

struct TimelineItem: Identifiable {
    let id: UUID
    let type: EntryType
    let time: Date
    let title: String
    let subtitle: String
}
