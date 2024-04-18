//
//  HabitTrackApp.swift
//  HabitTrack
//
//  Created by Jake Maidment on 13/04/2024.
//
import SwiftData
import SwiftUI

@main
struct HabitTrackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
