//
//  DateExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 10/21/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension Date {
    func startOfDate() -> Date {
//        formatter.calendar = Calendar(identifier: .persian)
//        formatter.locale = Locale(identifier: "fa_IR")
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self) //eg. yyyy-mm-dd 00:00:00
    }
    
    func nextDay() -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: self)
    }
    
    func toDBFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func toTaskTableFormatString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    } //TODO: Test
}
