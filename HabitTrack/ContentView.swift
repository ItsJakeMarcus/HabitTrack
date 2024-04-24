//
//  ContentView.swift
//  HabitTrack
//
//  Created by Jake Maidment on 13/04/2024.
// 

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
                .navigationDestination(for: Habit.self) { habit in
                                    EditHabitView(habit: habit)
                                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: addHabit) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                     Text("Active Habits")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
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
