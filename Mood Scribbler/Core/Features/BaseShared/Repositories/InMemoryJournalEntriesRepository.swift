//
//  InMemoryJournalEntriesRepository.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/28/24.
//

import Foundation

enum RepositoryError: Error {
    case notFound
    case unknown
    case emptyData
    case deleteFailed
    case updateFailed
    case saveFailed
}

// actors to designed to handle data safely, since actors can only execute one method at a time
actor InMemoryJournalEntriesRepository: JournalEntriesRepository {
    private var entries: [JournalEntry] = PreviewMockDataHelper.fewJournalEntries

    func create(_ journalEntry: JournalEntry) async throws(RepositoryError) {
        do {
            try await Task.sleep(nanoseconds: 1 * 500_000_000)
            entries.append(journalEntry)
        } catch RepositoryError.saveFailed {
            throw .saveFailed
        } catch {
            throw .unknown
        }
    }

    func retrieve(for id: String) async throws(RepositoryError) -> JournalEntry {
        do {
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            let entry = entries.first(where: { $0.id == id})
            guard let entry else {
                throw RepositoryError.notFound
            }
            return entry
        } catch RepositoryError.notFound {
            throw .notFound
        } catch {
            throw .unknown
        }
    }

    func retrieveAll() async throws(RepositoryError) -> [JournalEntry] {
        do {
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            guard !entries.isEmpty else {
                throw RepositoryError.emptyData
            }
            return entries
        } catch RepositoryError.emptyData {
            throw .emptyData
        } catch {
            throw .unknown
        }
    }

    func update(for id: String, with toBeUpdatedJournalEntry: JournalEntry) async throws(RepositoryError) {
        do {
            try await Task.sleep(nanoseconds: 1 * 500_000_000)
            guard let index = entries.firstIndex(where: { $0.id == id}) else {
                throw RepositoryError.updateFailed
            }
            let fetchedEntry = entries[index]
            if fetchedEntry.content != toBeUpdatedJournalEntry.content || fetchedEntry.wellBeingRating != toBeUpdatedJournalEntry.wellBeingRating {
                entries[index] = toBeUpdatedJournalEntry
            }
        } catch RepositoryError.updateFailed {
            throw .updateFailed
        } catch {
            throw .unknown
        }
    }

    func delete(for id: String) async throws(RepositoryError) {
        do {
            try await Task.sleep(nanoseconds: 1 * 500_000_000)
            guard let index = entries.firstIndex(where: { $0.id == id}) else {
                throw RepositoryError.deleteFailed
            }
            entries.remove(at: index)
        } catch RepositoryError.deleteFailed {
            throw .notFound
        } catch {
            throw .unknown
        }
    }
}

