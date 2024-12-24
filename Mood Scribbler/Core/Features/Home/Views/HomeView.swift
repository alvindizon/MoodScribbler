//
//  ContentView.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/15/24.
//

import SwiftUI

struct HomeView: View {
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
                Text(entry.postDate.description)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 38)
    }
    private var addButton: some View {
        Button {

        } label: {
            Image(systemName: "plus.app")
                .font(.system(size: 18, weight: .semibold))
        }
    }
}

#Preview {
    HomeView()
}
