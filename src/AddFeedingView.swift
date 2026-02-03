import SwiftUI

struct AddFeedingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: LogStore
    @State private var amount = ""
    @State private var time = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Amount (ml)", text: $amount)
                    .keyboardType(.numberPad)
                DatePicker("Time", selection: $time)
            }
            .navigationTitle("Add Feeding")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let val = Int(amount) { store.addFeeding(amount: val, time: time) }
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
