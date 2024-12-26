//
//  AdaptableHeightPreferenceKey.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/26/24.
//

import Foundation
import SwiftUI

// passes height values from child to parent
struct AdaptableHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout Value, nextValue: () -> Value) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}
