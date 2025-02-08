//
//  LocalJournalEntryRepository.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 2/8/25.
//

import SwiftData
import Foundation

@ModelActor
actor LocalJournalEntryRepository: JournalEntriesRepository {

    func create(_ journalEntry: JournalEntry) async throws(RepositoryError) {
        let localJournalEntry = JournalEntryLocalModel(
            id: journalEntry.id,
            postDate: journalEntry.postDate,
            content: journalEntry.content,
            wellBeingRating: journalEntry.wellBeingRating
        )
        modelContext.insert(localJournalEntry)
        do {
            try modelContext.save()
        } catch {
            throw .saveFailed
        }
    }

    func retrieve(for id: String) async throws(RepositoryError) -> JournalEntry {
        return JournalEntry(postDate: Date(), content: "None", wellBeingRating: 3)
    }

    @MainActor
    private func retrieveLocalModel(for id: String) async throws(RepositoryError) -> JournalEntryLocalModel {
        let predicate = #Predicate<JournalEntryLocalModel> {
            $0.id == id
        }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            if let journalLocalModel = try modelContainer.mainContext.fetch(descriptor).first {
                return journalLocalModel
            }
            throw RepositoryError.fetchFailed
        } catch {
            throw .fetchFailed
        }
    }

    @MainActor
    func retrieveAll() async throws(RepositoryError) -> [JournalEntry] {
        do {
            let journalEntriesLocal = try modelContainer.mainContext.fetch(FetchDescriptor<JournalEntryLocalModel>())
            var journalEntries: [JournalEntry] = []

            journalEntries = journalEntriesLocal.map{
                JournalEntry(
                    id: $0.id,
                    postDate: $0.postDate,
                    content: $0.content,
                    wellBeingRating: $0.wellBeingRating
                )
            }
            return journalEntries
        } catch {
            throw .fetchFailed
        }
    }

    func update(for id: String, with toBeUpdatedJournalEntry: JournalEntry) async throws(RepositoryError) {
        // fetch based on id only one journal entry
        // check if it needs to be updated
        // save it

        do {
            let fetchLocalJournal = try await self.retrieveLocalModel(for: id)
            if fetchLocalJournal.content != toBeUpdatedJournalEntry.content ||
                fetchLocalJournal.wellBeingRating != fetchLocalJournal.wellBeingRating {
                fetchLocalJournal.content = toBeUpdatedJournalEntry.content
                fetchLocalJournal.wellBeingRating = toBeUpdatedJournalEntry.wellBeingRating
            }
            try modelContext.save()
        } catch {
            throw .updateFailed
        }

    }

    func delete(for id: String) async throws(RepositoryError) {
        do {
            try modelContext.delete(
                model: JournalEntryLocalModel.self,
                where: #Predicate{ $0.id == id
                })
            try modelContext.save()
        } catch {
            throw .deleteFailed
        }

    }

    func retrieveAllError() async throws(RepositoryError) -> [JournalEntry] {
        return []
    }


}
