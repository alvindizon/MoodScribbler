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
    private var currentSelectedJournalEntry: JournalEntry?

    init(journalEntriesRepository: JournalEntriesRepository = InMemoryJournalEntriesRepository()) {
        self.journalEntriesRepository = journalEntriesRepository
    }

     func fillJournalData(for entry: JournalEntry) {
        self.journalContent = entry.content
        self.rating = entry.wellBeingRating
        self.currentSelectedJournalEntry = entry
    }

    func checkIfDataIsPresent() -> Bool {
        return !journalEntries.isEmpty
    }

    func saveOrUpdateJournalEntry() async {
        if currentSelectedJournalEntry == nil {
            await saveJournalEntry()
        } else {
            await updateJournalEntry()
        }
    }

    private func updateJournalEntry() async {
        // this code is executed every time scope of this function is terminated, but only if we're not using async
//        defer {
//            resetJournalContent()
//        }
        // make sure currentSelectedJournalEntry is not nil and journalContent is not empty
        guard let entry = currentSelectedJournalEntry, !journalContent.isEmpty else {
            await resetJournalContent()
            return
        }
        // make sure updated entry/rating is not same as current content
        guard entry.content != journalContent || entry.wellBeingRating != rating else {
            await resetJournalContent()
            return
        }
        // creating entry
        let toBeUpdatedEntry = JournalEntry(postDate: entry.postDate, content: journalContent, wellBeingRating: rating)

        do {
            try await journalEntriesRepository.update(for: entry.id, with: toBeUpdatedEntry)
            await retrieveAllJournalEntries()
        } catch {
            debugPrint("Error updating journal entry: \(error)")
        }

        await resetJournalContent()
    }

    private func saveJournalEntry() async {
        guard !journalContent.isEmpty else { return }
        let journalEntry = JournalEntry(postDate: Date(), content: journalContent, wellBeingRating: rating)

        do {
            try await journalEntriesRepository.create(journalEntry)
            await retrieveAllJournalEntries()
        } catch  {
            debugPrint("Error creating a journal entry! \(error)")
        }
        // reset journal content and rating
        await resetJournalContent()
    }

    func retrieveAllJournalEntries() async {
        let entries = try? await journalEntriesRepository.retrieveAll()
        // sort most recent to be first on list
        let sortedEntries = entries?.sorted { $0.postDate > $1.postDate }
        // if an error occurs, pass an empty array
        await MainActor.run {
            journalEntries = sortedEntries ?? []
        }
    }

    private func resetJournalContent() async {
        // update UI in main thread
        await MainActor.run {
            // reset journal content and rating
            journalContent.removeAll()
            currentSelectedJournalEntry = nil
            rating = 3
        }

    }

    func deleteJournalEntry(journalEntry: JournalEntry) async {
        do {
            try await journalEntriesRepository.delete(for: journalEntry.id)
            await retrieveAllJournalEntries()
        } catch {
            debugPrint("Error deleting a journal Entry \(error)")
        }
    }
}
