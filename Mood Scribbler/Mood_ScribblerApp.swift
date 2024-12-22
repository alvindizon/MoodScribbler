//
//  Mood_ScribblerApp.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/15/24.
//

import SwiftUI

@main
struct Mood_ScribblerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.font, CustomFont.body)
        }
    }
}
