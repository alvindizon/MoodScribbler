//
//  ContentView.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/15/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showSheet: Bool = false
    @State private var detentHeight: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                AppColorTheme.backgroundColor.ignoresSafeArea()
                mainContent
                    .navigationTitle("Mood scribbler")
                    .toolbarBackground(AppColorTheme.secondaryBackgroundColor, for: .navigationBar)
                    .toolbarBackgroundVisibility(.visible, for: .navigationBar)
                    .toolbar{
                        addButton
                    }
                    .sheet(isPresented: $showSheet) {

                    } content: {
                        sheetContentView
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
            ForEach(PreviewMockDataHelper.journalEntries) { entry in
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
            AddJournalEntryView()
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
}

#Preview {
    HomeView()
}
