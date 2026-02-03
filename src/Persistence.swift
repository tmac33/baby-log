import Foundation

final class Persistence {
    static let shared = Persistence()
    private init() {}

    private var baseURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var feedURL: URL { baseURL.appendingPathComponent("feedings.json") }
    private var diaperURL: URL { baseURL.appendingPathComponent("diapers.json") }

    func saveFeedings(_ items: [FeedingEntry]) {
        save(items, to: feedURL)
    }

    func saveDiapers(_ items: [DiaperEntry]) {
        save(items, to: diaperURL)
    }

    func loadFeedings() -> [FeedingEntry] {
        load(from: feedURL) ?? []
    }

    func loadDiapers() -> [DiaperEntry] {
        load(from: diaperURL) ?? []
    }

    private func save<T: Codable>(_ items: [T], to url: URL) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Save error: \(error)")
        }
    }

    private func load<T: Codable>(from url: URL) -> [T]? {
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            return nil
        }
    }
}
