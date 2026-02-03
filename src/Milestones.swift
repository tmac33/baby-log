import Foundation

struct Milestone: Identifiable {
    let id = UUID()
    let month: Int
    let title: String
}

final class MilestoneManager {
    static let shared = MilestoneManager()

    let milestones: [Milestone] = [
        Milestone(month: 2, title: "社交微笑"),
        Milestone(month: 3, title: "翻身 (俯卧到仰卧)"),
        Milestone(month: 4, title: "翻身 (仰卧到俯卧)"),
        Milestone(month: 6, title: "独坐"),
        Milestone(month: 6, title: "开始长牙"),
        Milestone(month: 8, title: "爬行"),
        Milestone(month: 9, title: "扶站"),
        Milestone(month: 12, title: "独走"),
        Milestone(month: 12, title: "叫爸妈 (简单词汇)"),
    ]

    func upcoming(for birthDate: Date, withinMonths: Int = 3) -> [Milestone] {
        let cal = Calendar.current
        let now = Date()
        let ageMonths = cal.dateComponents([.month], from: birthDate, to: now).month ?? 0
        return milestones.filter { $0.month >= ageMonths && $0.month <= ageMonths + withinMonths }
    }
}
