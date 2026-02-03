import Foundation


struct Baby: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var birthDate: Date
}

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
    var babyId: UUID
    var time: Date
    var amountML: Int
    var note: String?
}

struct DiaperEntry: Identifiable, Codable {
    let id: UUID
    var babyId: UUID
    var time: Date
    var type: DiaperType
    var note: String?
}


struct GrowthEntry: Identifiable, Codable {
    let id: UUID
    var babyId: UUID
    var time: Date
    var heightCM: Double
    var weightKG: Double
    var headCircumferenceCM: Double
}


enum ScheduleType: String, Codable, CaseIterable {
    case vaccine
    case checkup
}

struct ScheduleEntry: Identifiable, Codable {
    let id: UUID
    var babyId: UUID
    var time: Date
    var type: ScheduleType
    var title: String
    var note: String?
}

struct TimelineItem: Identifiable {
    let id: UUID
    let type: EntryType
    let time: Date
    let title: String
    let subtitle: String
}
