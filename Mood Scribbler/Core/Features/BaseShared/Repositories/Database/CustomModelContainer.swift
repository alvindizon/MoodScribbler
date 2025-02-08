//
//  CustomModelContainer.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 2/8/25.
//
import SwiftData

final class CustomModelContainer {
    static let container: ModelContainer = {
        do {
            let schema = Schema([JournalEntryLocalModel.self])
            return try ModelContainer(for: schema, configurations: [])
        } catch {
            fatalError("Failed to create a ModelContainer: \(error)")
        }
    }()
}
