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
    // @State is a property wrapper--SwiftUI will trigger a rebuild if value changes
    @State private var showSheet: Bool = false
    @State private var detentHeight: CGFloat = 0
    @State private var shouldCreateNewJournalEntry: Bool = false
    @State private var showToolbarLoadingSpinner: Bool = false
    @State private var showLoadingSpinner: Bool = false


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
                        await viewModel.saveOrUpdateJournalEntry()
                        showToolbarLoadingSpinner = false
                        shouldCreateNewJournalEntry = false
                    }
                    .task {
                        showLoadingSpinner = true
                        await viewModel.retrieveAllJournalEntriesError()
                        showLoadingSpinner = false
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
        // lets you place a view on top of another
        .overlay {
            if showLoadingSpinner {
                loadingSpinnerView
            } else if let _ = viewModel.errorMessage {
                errorStateView
            } else if !viewModel.checkIfDataIsPresent() {
                emptyStateView
            }
        }
    }

    private var loadingSpinnerView: some View {
        ProgressView("Loading...")
            .progressViewStyle(.circular)
            .padding()
            .controlSize(.large)
            .tint(AppColorTheme.accentColor)
            .foregroundStyle(AppColorTheme.whiteColor)
            .bold()
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No journal entries yet", systemImage: "document")
                .foregroundStyle(AppColorTheme.secondaryTextColor)
        } description: {
            Text("You don't have any saved entries yet.")
                .foregroundStyle(AppColorTheme.secondaryTextColor)
        } actions: {
            Button("Create a new entry here") {
                showSheet.toggle()
            }
            .buttonStyle(.bordered)
        }
    }

    private var errorStateView: some View {
        ContentUnavailableView {
            Label("There was an error.", systemImage: "x.circle")
                .foregroundStyle(AppColorTheme.errorColor)
        } description: {
            Text(viewModel.errorMessage ?? "")
                .foregroundStyle(AppColorTheme.secondaryTextColor)
        } actions: {
            Button("Retry") {
               Task {
                    showLoadingSpinner = true
                    await viewModel.retrieveAllJournalEntriesError()
                    showLoadingSpinner = false
                }
            }
            .buttonStyle(.bordered)
        }
    }

    private var cells: some View {
        // LazyVStack only loads items as they become visible, making it ideal for displaying large lists
        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.journalEntries) { entry in
                JournalCell(journalEntry: entry) {
                    showBottomSheetWithData(for: entry)
                }
                .contextMenu {
                    Button {
                        Task {
                            self.showToolbarLoadingSpinner = true
                            await viewModel.deleteJournalEntry(journalEntry: entry)
                            self.showToolbarLoadingSpinner = false
                        }

                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 38)
    }

    private func showBottomSheetWithData(for entry: JournalEntry) {
        // populate
        viewModel.fillJournalData(for: entry)
        showSheet.toggle()
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
