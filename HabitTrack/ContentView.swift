//
//  ContentView.swift
//  HabitTrack
//
//  Created by Jake Maidment on 13/04/2024.
// test

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme

    @State private var path = [Habit]()
    @State private var sortOrder = SortDescriptor(\Habit.name)
    @State private var searchText = ""

    var body: some View {
        NavigationStack(path: $path) {
            HabitListingView()
                .navigationTitle("Habit Track")
                .navigationDestination(for: Habit.self, destination: EditHabitView.init)
                //.searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: addHabit) {
                            Image(systemName: "plus")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
        }
    }

    func addHabit() {
        let habit = Habit()
        modelContext.insert(habit)
        path = [habit]
    }
}

#Preview {
    ContentView()
}
