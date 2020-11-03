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
    
    func getHourString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: self)
    }
    
    func getMinString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: self)
    }
    
    func toPersianTimeString() -> String {
        let hour = self.getHourString().convertEnglishNumToPersianNum()
        let min = self.getMinString().convertEnglishNumToPersianNum()
        return "\(hour):\(min)"
    }
    
    func toPersianDateString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    } //TODO: test
    
    func toCompletePersianString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
