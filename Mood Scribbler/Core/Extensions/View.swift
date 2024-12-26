//
//  View.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/26/24.
//

import Foundation
import SwiftUI

extension View {
    func readAndBindHeight(to height: Binding<CGFloat>) -> some View {
        self.modifier(AdaptableHeightModifier(currentHeight: height))
    }
}
