//
//  JournalCell.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/24/24.
//

import SwiftUI

struct JournalCell: View {
    let journalEntry: JournalEntry
    var onButtonPressed: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerView
            journalContentView
            ratingView
        }
        // to modify text color, use foregroundStyle modifier
        .foregroundStyle(AppColorTheme.whiteColor)
        .padding()
        .background(AppColorTheme.secondaryBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension JournalCell {
    private var ratingView: some View {
        Text(String(format: "%d / 5", journalEntry.wellBeingRating))
            .font(CustomFont.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(AppColorTheme.whiteColor)
        // add a rounded rectange around (technically in front) of the rating text
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(AppColorTheme.secondaryTextColor, lineWidth: 1)
            }
            .padding(.top, 8)
            .bold()
    }

    private var journalContentView: some View {
        Text(journalEntry.content)
            .lineLimit(2)
    }
    private var showMoreView: some View {
        Button {
            onButtonPressed()
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(AppColorTheme.accentColor)
                .fontWeight(.semibold)
                .font(.title3)
        }
    }
    private var headerView: some View {
        HStack {
            Image(systemName: "calendar")
            Text(journalEntry.postDate.formattedAsDayMonthYear())
                .font(CustomFont.callout)
            Spacer()
            showMoreView

        }
        .foregroundStyle(AppColorTheme.secondaryTextColor)
    }
}

#Preview(traits: .sizeThatFitsLayout){
    JournalCell(journalEntry: PreviewMockDataHelper.journalEntry){}
        .padding()
}
