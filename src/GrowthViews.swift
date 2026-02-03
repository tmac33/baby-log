import SwiftUI
import Charts

struct GrowthBoardView: View {
    @ObservedObject var store: LogStore
    @State private var showAdd = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Growth Board").font(.headline)
                Spacer()
                Button("Add") { showAdd = true }
            }

            GrowthChartsView(entries: store.currentGrowth)
        }
        .sheet(isPresented: $showAdd) {
            AddGrowthView(store: store)
        }
    }
}

struct GrowthChartsView: View {
    let entries: [GrowthEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Height (cm)").font(.subheadline)
            Chart(entries) { e in
                LineMark(x: .value("Date", e.time), y: .value("Height", e.heightCM))
            }
            .chartYScale(domain: 30...100)
            .frame(height: 140)

            Text("Weight (kg)").font(.subheadline)
            Chart(entries) { e in
                LineMark(x: .value("Date", e.time), y: .value("Weight", e.weightKG))
            }
            .chartYScale(domain: 2...20)
            .frame(height: 140)

            Text("Head Circumference (cm)").font(.subheadline)
            Chart(entries) { e in
                LineMark(x: .value("Date", e.time), y: .value("Head", e.headCircumferenceCM))
            }
            .chartYScale(domain: 30...60)
            .frame(height: 140)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct AddGrowthView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: LogStore
    @State private var height = ""
    @State private var weight = ""
    @State private var head = ""
    @State private var time = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Height (cm)", text: $height).keyboardType(.decimalPad)
                TextField("Weight (kg)", text: $weight).keyboardType(.decimalPad)
                TextField("Head circumference (cm)", text: $head).keyboardType(.decimalPad)
                DatePicker("Time", selection: $time)
            }
            .navigationTitle("Add Growth")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let h = Double(height) ?? 0
                        let w = Double(weight) ?? 0
                        let hc = Double(head) ?? 0
                        store.addGrowth(heightCM: h, weightKG: w, headCM: hc, time: time)
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
