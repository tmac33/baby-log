import SwiftUI

struct AddDiaperView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: LogStore
    @State private var type: DiaperType = .wet
    @State private var time = Date()

    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(DiaperType.allCases, id: \.self) { t in
                        Text(t.rawValue.capitalized)
                    }
                }
                DatePicker("Time", selection: $time)
            }
            .navigationTitle("Add Diaper")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addDiaper(type: type, time: time)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
