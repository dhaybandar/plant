//
//  PlantListView.swift
//  Planto
//

import SwiftUI

struct PlantListView: View {
    @EnvironmentObject private var store: PlantStore
    @State private var showAdd = false
    @State private var plantToEdit: Plant?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                Header()

                if store.plants.isEmpty {
                    Spacer()
                    Text("No reminders set yet..")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                    Spacer()
                } else if store.allDone {
                    AllDoneView()
                } else {
                    VStack(spacing: 10) {
                        Text(store.doneCount == 0
                             ? "Your plants are waiting for a sip 💦"
                             : "\(store.doneCount) of your plants feel loved today ✨")
                            .font(.caption)
                            .foregroundStyle(Theme.primaryText)
                            .padding(.top, 16)
                            .animation(.none, value: store.doneCount)
                        PlantProgressBar(progress: store.progress)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 8)

                    List {
                        ForEach(store.plants) { plant in
                            PlantRow(
                                plant: plant,
                                onToggle: {
                                    withAnimation(.easeInOut) {
                                        store.toggle(plant)
                                    }
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture { plantToEdit = plant }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(Theme.separator)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        store.delete(plant)
                                    }
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

            Button {
                showAdd = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel("Add plant")
            .glassEffect(.regular.tint(Theme.button).interactive(), in: Circle())
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .animation(.easeInOut, value: store.allDone)
        .sheet(isPresented: $showAdd) {
            ReminderSheet(plant: nil)
        }
        .sheet(item: $plantToEdit) { plant in
            ReminderSheet(plant: plant)
        }
    }
}
