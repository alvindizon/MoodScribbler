//
//  JournalEntriesRepository.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/28/24.
//

import Foundation

protocol JournalEntriesRepository {
    // create
    // retrieve, get, fetch one journal entry based on ID
    // retrieve all journal entries
    // update (id, data to be updated with)
    // delete

    func create(_ journalEntry: JournalEntry) async throws(RepositoryError)
    func retrieve(for id: String) async throws(RepositoryError) -> JournalEntry
    func retrieveAll() async throws(RepositoryError) -> [JournalEntry]
    func update(for id: String, with toBeUpdatedJournalEntry: JournalEntry) async throws(RepositoryError)
    func delete(for id: String) async throws(RepositoryError)
    func retrieveAllError() async throws(RepositoryError) -> [JournalEntry]
}
