//
//  JournalEntry.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/24/24.
//

import Foundation

// each instance of JournalEntry is unique, which allows SwiftUI each instance via ID
// this allows SwiftUI to efficiently render lists, only needing to display changed items rather
// than all items
struct JournalEntry: Identifiable {
    let id: String = UUID().uuidString
    let postDate: Date
    let content: String
    let wellBeingRating: Int // 1 -> 5

}
