//
//  AddJournalEntryView.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/25/24.
//

import SwiftUI

struct AddJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animationsRunning: Bool = false
    // Binding is a way to create a two-way connection between the property and the view
    // It lets the view update the property, and reacts to changes in the property automatically
    @Binding var dayDetails: String
    @Binding var ratingSelection: Int

    var body: some View {
        VStack {
            closeButton
                .padding(.vertical)
            heroSection
            textFieldView
            ratingPickerView
            Spacer()
        }
        .padding(18)
        .onAppear {
            animationsRunning.toggle()
        }
    }
}

extension AddJournalEntryView {
    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.app")
                    .font(.title)
            }
            .foregroundStyle(AppColorTheme.whiteColor)
        }
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "face.dashed.fill")
                // need to change rendering mode to allow animation
                .symbolRenderingMode(.palette)
                .foregroundStyle(
                    AppColorTheme.accentColor, AppColorTheme.whiteColor
                )
                .font(.system(size: 52))
            Text("How do you feel today?")
                .font(CustomFont.title)
                .bold()
                .padding(.bottom, 16)
                // controls how small the text can shrink when it needs to fit a screen
                // 0.8 means that text will shrink to 80% of its size
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundStyle(AppColorTheme.whiteColor)
        }
        .symbolEffect(
            .breathe, options: .repeat(2).speed(1.2), value: animationsRunning)
    }

    private var textFieldView: some View {
        TextField(
            "",
            text: $dayDetails,
            prompt: Text("Details here..").foregroundStyle(
                AppColorTheme.whiteColor.opacity(0.5)),
            axis: .vertical
        )
        .foregroundStyle(AppColorTheme.whiteColor)
        .font(CustomFont.body)
        .fontWeight(.semibold)
        .padding()
        // reserve space for 8 lines. if false, then textfield will only expand
        // based on text inputted
        .lineLimit(8, reservesSpace: true)
        .background(AppColorTheme.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var ratingPickerView: some View {
        HStack(spacing: 16) {
            Spacer()
            Text("Day rating:")
                .textCase(.uppercase)
                .bold()
                .font(CustomFont.callout)
            Menu {
                ForEach(HomeConstants.wellbeingRatingOptions, id: \.self) { rating in
                    Button(String(rating)) {
                        ratingSelection = rating
                    }
                }
            } label: {
                Text(String(format: "%d / 5", ratingSelection))
                    .padding(10)
                    .bold()
                    .background {
                        RoundedRectangle(cornerRadius: 10).fill(AppColorTheme.backgroundColor)
                    }
                // this modifier prevents the momentary clipping that happens to the RoundedRectangle when changing ratings
                    .fixedSize()
            }
        }
        .padding(.top)
    }
}

#Preview {
    @Previewable @State var detentHeight: CGFloat = 0
    @Previewable @State var selection = 1
    ZStack {
        AppColorTheme.backgroundColor.ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                AddJournalEntryView(
                    dayDetails: .constant(""),
                    ratingSelection: $selection
                )
                    .presentationDetents([.height(detentHeight)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.thinMaterial)
                    .fixedSize(horizontal: false, vertical: true)
                    .readAndBindHeight(to: $detentHeight)
            }
    }
}
