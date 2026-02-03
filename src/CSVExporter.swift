import Foundation

final class CSVExporter {
    func export(feedings: [FeedingEntry], diapers: [DiaperEntry]) -> URL? {
        let header = "type,time,amount_ml,diaper_type,note\n"
        let df = ISO8601DateFormatter()

        var rows: [String] = [header]

        for f in feedings {
            let t = df.string(from: f.time)
            let note = (f.note ?? "").replacingOccurrences(of: ",", with: " ")
            rows.append("feeding,\(t),\(f.amountML),,\(note)\n")
        }

        for d in diapers {
            let t = df.string(from: d.time)
            let note = (d.note ?? "").replacingOccurrences(of: ",", with: " ")
            rows.append("diaper,\(t),,\(d.type.rawValue),\(note)\n")
        }

        let csv = rows.joined()
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("baby-log.csv")
        do {
            try csv.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            return nil
        }
    }
}
