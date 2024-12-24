//
//  Date.swift
//  Mood Scribbler
//
//  Created by Alvin Dizon on 12/24/24.
//

import Foundation

extension Date {
    func formattedAsDayMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy" // 13 Oct 1993
        return formatter.string(from: self)
    }
}
