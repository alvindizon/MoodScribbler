//
//  HomeViewModel.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/26/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published private(set) var journalEntries: [JournalEntry] = []
    @Published private(set) var showToolbarLoadingSpinner: Bool = false

    init() {
        fetchData()
    }

    private func fetchData() {
        showToolbarLoadingSpinner = true
        // simulate fetching by adding a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.journalEntries = PreviewMockDataHelper.fewJournalEntries
            self.showToolbarLoadingSpinner = false
        }
    }
}
