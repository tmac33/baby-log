import SwiftUI

struct ScheduleBoardView: View {
    @ObservedObject var store: LogStore
    @State private var showAdd = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Schedule").font(.headline)
                Spacer()
                Button("Add") { showAdd = true }
            }

            List(store.currentSchedule) { item in
                VStack(alignment: .leading) {
                    Text(item.title).bold()
                    Text(item.type.rawValue.capitalized)
                    Text(item.time.formatted())
                }
            }
            .frame(height: 220)
        }
        .sheet(isPresented: $showAdd) {
            AddScheduleView(store: store)
        }
    }
}

struct AddScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: LogStore
    @State private var type: ScheduleType = .vaccine
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var time: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(ScheduleType.allCases, id: \.self) { t in
                        Text(t.rawValue.capitalized)
                    }
                }
                TextField("Title", text: $title)
                TextField("Note", text: $note)
                DatePicker("Time", selection: $time)
            }
            .navigationTitle("Add Schedule")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addSchedule(type: type, title: title, time: time, note: note.isEmpty ? nil : note)
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
