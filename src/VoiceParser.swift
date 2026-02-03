import Foundation

struct ParsedCommand {
    var type: EntryType
    var time: Date
    var amountML: Int?
    var diaperType: DiaperType?
    var note: String
}

final class VoiceParser {
    func parse(_ text: String, now: Date = Date()) -> ParsedCommand? {
        let lower = text.lowercased()
        let isFeeding = lower.contains("喝奶") || lower.contains("喂奶") || lower.contains("奶量") || lower.contains("ml") || lower.contains("毫升") || lower.contains("cc")
        let isDiaper = lower.contains("尿布") || lower.contains("换尿布") || lower.contains("大便") || lower.contains("小便") || lower.contains("wet") || lower.contains("dirty")
        if !isFeeding && !isDiaper { return nil }

        if isFeeding {
            let amount = extractAmount(lower)
            return ParsedCommand(type: .feeding, time: now, amountML: amount, diaperType: nil, note: text)
        } else {
            let dType = extractDiaperType(lower)
            return ParsedCommand(type: .diaper, time: now, amountML: nil, diaperType: dType, note: text)
        }
    }

    private func extractAmount(_ text: String) -> Int? {
        let pattern = #"(\d+)\s*(ml|毫升|cc)?"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                if let r1 = Range(match.range(at: 1), in: text) {
                    return Int(text[r1])
                }
            }
        }
        return nil
    }

    private func extractDiaperType(_ text: String) -> DiaperType {
        let wet = text.contains("湿") || text.contains("小便") || text.contains("wet")
        let dirty = text.contains("臭") || text.contains("大便") || text.contains("dirty")
        if wet && dirty { return .mixed }
        if dirty { return .dirty }
        return .wet
    }
}
