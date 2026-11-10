import SwiftUI
 
// MARK: - Root: يربط الصفحات ببعض
 
struct ContentView: View {
    @EnvironmentObject var store: PlantStore
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @State private var showOnboardingSheet = false
 
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
 
            if !hasOnboarded && store.plants.isEmpty {
                // 1) Start your plant journey!
                OnboardingView { showOnboardingSheet = true }
            } else {
                // 2) My Plants (No reminders / Today / All Done)
                PlantListView()
            }
        }
        .sheet(isPresented: $showOnboardingSheet) {
            ReminderSheet(plant: nil) { hasOnboarded = true }
        }
    }
}
 
// MARK: - 1) Onboarding
 
struct OnboardingView: View {
    let onStart: () -> Void
 
    var body: some View {
        VStack(spacing: 0) {
            Header()
            Spacer()
            Mascot(size: 170)
            Text("Start your plant journey!")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.top, 24)
            Text("Now all your plants will be in one place and\nwe will help you take care of them :) 🪴")
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            Spacer()
            Button(action: onStart) {
                Text("Set Plant Reminder")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.button, in: Capsule())
            }
            .padding(.horizontal, 60)
            .padding(.bottom, 40)
        }
    }
}
 
// MARK: - Header "My Plants 🌱"
 
struct Header: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Plants \(Image(systemName: "leaf.fill"))")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            Divider().overlay(Color(white: 0.2))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
 
// MARK: - 2) Plant list (+ empty / all done states)
 
struct PlantListView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showAdd = false
    @State private var plantToEdit: Plant?
 
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                Header()
 
                if store.plants.isEmpty {
                    // No reminders
                    Spacer()
                    Text("No reminders set yet..")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                } else if store.allDone {
                    // All Reminders Completed
                    AllDoneView()
                } else {
                    // Today reminders
                    VStack(spacing: 10) {
                        Text(store.doneCount == 0
                             ? "Your plants are waiting for a sip 💦"
                             : "\(store.doneCount) of your plants feel loved today ✨")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.top, 16)
                            .animation(.none, value: store.doneCount)
                        PlantProgressBar(progress: store.progress)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 8)
 
                    List {
                        ForEach(store.plants) { plant in
                            PlantRow(plant: plant,
                                     onToggle: {
                                         withAnimation(.easeInOut) { store.toggle(plant) }
                                     })
                            .contentShape(Rectangle())
                            .onTapGesture { plantToEdit = plant } // Edit
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(Color(white: 0.2))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation { store.delete(plant) }
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
 
            // زر الإضافة (+)
            Button { showAdd = true } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Theme.button, in: Circle())
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .animation(.easeInOut, value: store.allDone)
        .sheet(isPresented: $showAdd) { ReminderSheet(plant: nil) }
        .sheet(item: $plantToEdit) { plant in ReminderSheet(plant: plant) }
    }
}
 
// MARK: - Row
 
struct PlantRow: View {
    let plant: Plant
    let onToggle: () -> Void
 
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: plant.isDoneToday ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(plant.isDoneToday ? Theme.accent : Color(white: 0.5))
            }
            .buttonStyle(.plain)
 
            VStack(alignment: .leading, spacing: 6) {
                Label("in \(plant.room.rawValue)", systemImage: "location")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                Text(plant.name)
                    .font(.title3)
                    .foregroundStyle(plant.isDoneToday ? .secondary : Color.white)
                HStack(spacing: 8) {
                    Chip(icon: plant.light.icon, text: plant.light.rawValue)
                    Chip(icon: "drop", text: plant.water.rawValue)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
 
// MARK: - All Done
 
struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Mascot(size: 170)
            Text("All Done! 🎉")
                .font(.headline)
                .foregroundStyle(.white)
            Text("All Reminders Completed")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .transition(.opacity)
    }
}
