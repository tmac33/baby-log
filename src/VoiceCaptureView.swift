import SwiftUI

struct VoiceCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: LogStore
    @State private var transcript = ""
    @State private var parsed: ParsedCommand? = nil
    private let parser = VoiceParser()

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Voice Input")
                    .font(.headline)
                TextField("Paste transcript here...", text: $transcript)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Parse") {
                    parsed = parser.parse(transcript)
                }
                .buttonStyle(.borderedProminent)

                if let p = parsed {
                    ParsedCard(parsed: p)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Voice")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let p = parsed else { return }
                        if p.type == .feeding, let amt = p.amountML {
                            store.addFeeding(amount: amt, time: p.time, note: p.note)
                        } else if p.type == .diaper, let dt = p.diaperType {
                            store.addDiaper(type: dt, time: p.time, note: p.note)
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct ParsedCard: View {
    let parsed: ParsedCommand

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Parsed Result").bold()
            Text("Type: \(parsed.type.rawValue)")
            if let amount = parsed.amountML { Text("Amount: \(amount) ml") }
            if let dt = parsed.diaperType { Text("Diaper: \(dt.rawValue)") }
            Text("Time: \(parsed.time.formatted())")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
