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
  

    init(name: String = "", details: String = "", score: Int = 0) {
        self.name = name
        self.details = details
        self.score = score
    }
}
