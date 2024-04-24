//
//  Habbit.swift
//  HabitTrack
//
//  Created by Jake Maidment on 13/04/2024.
//
import Foundation
import SwiftData

@Model
class Habit {
    var name: String
    var details: String
    var score: Int
    var color: Int
    let id = UUID()
    
  

    init(name: String = "", color: Int = 3, details: String = "", score: Int = 0) {
        self.name = name
        self.details = details
        self.score = score
        self.color = color
    }
}
