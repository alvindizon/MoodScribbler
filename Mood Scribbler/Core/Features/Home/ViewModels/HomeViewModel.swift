//
//  HomeViewModel.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/26/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var journalEntries: [JournalEntry] = []
    @Published var journalContent = ""
    @Published var rating: Int = 3
    private let journalEntriesRepository: JournalEntriesRepository

    init(journalEntriesRepository: JournalEntriesRepository = InMemoryJournalEntriesRepository()) {
        self.journalEntriesRepository = journalEntriesRepository
    }

    func checkIfDataIsPresent() -> Bool {
        return !journalEntries.isEmpty
    }

    func saveJournalEntry() async {
        guard !journalContent.isEmpty else { return }
        let journalEntry = JournalEntry(postDate: Date(), content: journalContent, wellBeingRating: rating)

        do {
            try await journalEntriesRepository.create(journalEntry)
            await retrieveAllJournalEntries()
        } catch  {
            debugPrint("Error creating a journal entry! \(error)")
        }
        // reset journal content and rating
        journalContent.removeAll()
        rating = 3
    }

    func retrieveAllJournalEntries() async {
        let entries = try? await journalEntriesRepository.retrieveAll()
        // sort most recent to be first on list
        let sortedEntries = entries?.sorted { $0.postDate > $1.postDate }
        // if an error occurs, pass an empty array
        journalEntries = sortedEntries ?? []
    }
}
