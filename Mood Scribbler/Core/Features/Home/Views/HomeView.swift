//
//  ContentView.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/15/24.
//

import SwiftUI

struct HomeView: View {
    // StateObject is used to manage the VM's lifecycle inside the Swift UI
    // ensures that the VM is only created once and retains its state, even if UI is re-rendered
    @StateObject private var viewModel = HomeViewModel()
    @State private var showSheet: Bool = false
    @State private var detentHeight: CGFloat = 0
    @State private var shouldCreateNewJournalEntry: Bool = false
    @State private var showToolbarLoadingSpinner: Bool = false


    var body: some View {
        NavigationStack {
            ZStack {
                AppColorTheme.backgroundColor.ignoresSafeArea()
                mainContent
                    .navigationTitle("Mood scribbler")
                    .toolbarBackground(AppColorTheme.secondaryBackgroundColor, for: .navigationBar)
                    .toolbarBackgroundVisibility(.visible, for: .navigationBar)
                    .toolbar{
                        if showToolbarLoadingSpinner {
                            toolBarProgressView
                        }
                        addButton
                    }
                    .sheet(isPresented: $showSheet) {
                        // trigger save method from the viewmodel
                        shouldCreateNewJournalEntry = true
                    } content: {
                        sheetContentView
                    }
                // runs async code when a view appears or when something triggers it
                // manages lifecycle-aware tasks, such as triggering something when something is first shown
                    .task(id: shouldCreateNewJournalEntry) {
                        // only execute if shouldCreateNewJournalEntry is true
                        guard shouldCreateNewJournalEntry else { return }
                        showToolbarLoadingSpinner = true
                        await viewModel.saveJournalEntry()
                        showToolbarLoadingSpinner = false
                        shouldCreateNewJournalEntry = false
                    }
                    .task {
                        await viewModel.retrieveAllJournalEntries()
                    }
            }
        }
    }
}

extension HomeView {
    private var mainContent: some View {
        ScrollView {
            cells
        }
    }

    private var cells: some View {
        // LazyVStack only loads items as they become visible, making it ideal for displaying large lists
        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.journalEntries) { entry in
                JournalCell(journalEntry: entry)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 38)
    }
    private var addButton: some View {
        Button {
            showSheet.toggle()
        } label: {
            Image(systemName: "plus.app")
                .font(.system(size: 18, weight: .semibold))
        }
    }
    private var sheetContentView: some View {
        ZStack {
            AppColorTheme.secondaryBackgroundColor.opacity(0.6).ignoresSafeArea()
            AddJournalEntryView(
                dayDetails: $viewModel.journalContent,
                ratingSelection: $viewModel.rating
            )
            // grow alongside content's width, but height should stay fixed
            .fixedSize(horizontal: false, vertical: true)
            .readAndBindHeight(to: $detentHeight)
        }
        .presentationDetents([.height(detentHeight)])
//        .presentationDetents([.fraction(0.8)])
        // Using [.medium] would cause bottom sheet content to be clipped
        .presentationDragIndicator(.visible)
        .presentationBackground(.ultraThinMaterial)
        .preferredColorScheme(.dark)

    }
    private var toolBarProgressView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(AppColorTheme.accentColor)
    }
}

#Preview {
    HomeView()
}
