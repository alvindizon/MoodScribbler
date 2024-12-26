//
//  AdaptableHeightModifier.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/26/24.
//

import Foundation
import SwiftUI

struct AdaptableHeightModifier: ViewModifier {
    @Binding var currentHeight: CGFloat

    private var sizeView: some View {
        // an invisible GeometryReader that gets the height of the content and passes it to the parent view
        GeometryReader { geometry in
            Color.clear
                .preference(key: AdaptableHeightPreferenceKey.self, value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content
        // apply the view with the invisible GeometryReader in the background
            .background(sizeView)
        // listen for changes using onPreferenceChange and updates currentHeight with the updated content of the height
        // this makes our UI responsive by updating its size based on its content in real time
            .onPreferenceChange(AdaptableHeightPreferenceKey.self) { height in
                if let height {
                    currentHeight = height
                }
            }
    }
}
