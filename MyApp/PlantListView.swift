//
//  PlantListView.swift
//  MyApp
//
//  Created by Dhay Bandar on 01/06/1448 AH.
//

import SwiftUI

// MARK: - Plant List View (+ empty / all done states)

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

#Preview {
    PlantListView()
        .environmentObject(PlantStore(plants: [
            Plant(name: "Pothos", room: .bedroom, light: .fullSun, wateringDays: .everyDay, water: .a)
        ]))
        .preferredColorScheme(.dark)
}
