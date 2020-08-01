//
//  File.swift
//  
//
//  Created by Matthew Schmulen on 8/1/20.
//

import Foundation

extension Date {
    var numberOfDaysOld: Double? {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for:Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if let days = components.day {
            return Double(days)
        } else {
            return nil
        }
    }
}



