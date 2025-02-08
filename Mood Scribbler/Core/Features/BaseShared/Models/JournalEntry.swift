//
//  JournalEntry.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/24/24.
//

import Foundation
import SwiftData

// each instance of JournalEntry is unique, which allows SwiftUI each instance via ID
// this allows SwiftUI to efficiently render lists, only needing to display changed items rather
// than all items
struct JournalEntry: Identifiable {
    let id: String
    let postDate: Date
    let content: String
    let wellBeingRating: Int // 1 -> 5

    init(
        id: String = UUID().uuidString,
        postDate: Date,
        content: String,
        wellBeingRating: Int
    ) {
        self.id = id
        self.postDate = postDate
        self.content = content
        self.wellBeingRating = wellBeingRating
    }
}

// Will only be used at the repository level
// Repository will map this to JournalEntry to UI and vice versa
@Model
class JournalEntryLocalModel {
    @Attribute(.unique) var id: String
    var postDate: Date
    var content: String
    var wellBeingRating: Int

    init(
        id: String,
        postDate: Date,
        content: String,
        wellBeingRating: Int
    ) {
        self.id = id
        self.postDate = postDate
        self.content = content
        self.wellBeingRating = wellBeingRating
    }
}
