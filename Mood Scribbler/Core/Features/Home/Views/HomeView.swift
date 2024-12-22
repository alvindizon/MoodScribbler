//
//  ContentView.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/15/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, scribblers!")
                .bold()
                .foregroundStyle(AppColorTheme.secondaryTextColor)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
