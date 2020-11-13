//
//  DateExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 10/21/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension Date {
    static func getDate(date: String) -> Date? {
        let dateFormatter = getPersianDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
    
    static private func getPersianDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa_IR")
        return formatter
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar(identifier: .persian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    
    func endOfMonth() -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .persian).date(byAdding: components, to: startOfMonth())!
    }
    
    func startOfDate() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self) //eg. yyyy-mm-dd 00:00:00
    }
    
    func nextDay() -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: self)
    }
    
    //MARK: To Strings
    func toDBFormatDateAndTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func toDBFormatDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
        print("MIN IS \(formatter.string(from: self))")
        return formatter.string(from: self)
    }
    
    func toPersianTimeString() -> String { //13:10
        let hour = self.getHourString().convertEnglishNumToPersianNum().makeTwoDigitPersian()
        let min = self.getMinString().convertEnglishNumToPersianNum().makeTwoDigitPersian()
        return "\(hour):\(min)"
    }
    
    func getPersianDateFormatterWith(format: String) -> DateFormatter {
        let formatter = Date.getPersianDateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
    func toPersianWeekDayString() -> String { //shanbe
        let formatter = getPersianDateFormatterWith(format: "EEEE")
        return formatter.string(from: self)
    }
    
    func toPersianDayString() -> String { //15
        let formatter = getPersianDateFormatterWith(format: "dd")
        return formatter.string(from: self)
    }
    
    func toPersianMonthString() -> String { //aban
        let formatter = getPersianDateFormatterWith(format: "MM")
        let monthNumber = formatter.string(from: self).convertPersianNumToEnglishNum()
        return formatter.monthSymbols[Int(monthNumber)! - 1]
    }
    
    func toCompletePersianString() -> String { //22 aban 1399, 20:14
        let formatter = Date.getPersianDateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func toPersianDMonthYString() -> String { //15 aban 1399
        let formatter = Date.getPersianDateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    func toPersianWeekDMonth() -> String { //panjshanbe 15 aban
        return toPersianWeekDayString() + " " + toPersianDayString() + " " + toPersianMonthString()
    }
    
    func toPersianShortString() -> String {
        let formatter = getPersianDateFormatterWith(format: "yy/MM/dd")
        return formatter.string(from: self)
    }
}
