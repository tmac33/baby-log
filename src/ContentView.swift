import SwiftUI

struct ContentView: View {
    @StateObject private var store = LogStore()
    @State private var showAddFeed = false
    @State private var showAddDiaper = false
    @State private var showVoice = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                summaryCard
                actionBar
                timelineList
            }
            .padding()
            .navigationTitle("Baby Log")
        }
        .sheet(isPresented: $showAddFeed) {
            AddFeedingView(store: store)
        }
        .sheet(isPresented: $showAddDiaper) {
            AddDiaperView(store: store)
        }
        .sheet(isPresented: $showVoice) {
            VoiceCaptureView(store: store)
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today Summary").font(.headline)
            HStack {
                VStack(alignment: .leading) {
                    Text("Last Feed")
                    Text(store.feedings.first.map { "\($0.amountML) ml" } ?? "-")
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Last Diaper")
                    Text(store.diapers.first?.type.rawValue.capitalized ?? "-")
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var actionBar: some View {
        HStack {
            Button("Feed") { showAddFeed = true }
                .buttonStyle(.borderedProminent)
            Button("Diaper") { showAddDiaper = true }
                .buttonStyle(.bordered)
            Button("Voice") { showVoice = true }
                .buttonStyle(.bordered)
        }
    }

    private var timelineList: some View {
        List(store.timeline) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title).bold()
                    Text(item.subtitle).font(.subheadline)
                }
                Spacer()
                Text(item.time, style: .time).font(.caption)
            }
        }
        .listStyle(.plain)
    }
}
