//
//  DateExtension.swift
//  Brandent
//
//  Created by Sara Babaei on 10/21/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension Date {
    
    static func defaultDate() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 1970
        components.month = 10
        components.day = 10
        components.hour = 10
        components.minute = 10
        components.second = 0
        return calendar.date(from: components)!
    }
    
    //MARK: Getting Specific Dates
    func startOfMonth() -> Date? {
        let calendar = Calendar(identifier: .persian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)
    }
    
    func endOfMonth() -> Date? {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        if let start = startOfMonth() {
            return Calendar(identifier: .persian).date(byAdding: components, to: start)
        }
        return nil
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
    
    //MARK: Setting Date Formatter
    private static func getDateFormatter(calendar: Calendar.Identifier?, isForSync: Bool) -> DateFormatter {
        let formatter = DateFormatter()
        if isForSync {
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
        }
        if let identifier = calendar, identifier == .persian {
            formatter.calendar = Calendar(identifier: .persian)
            formatter.locale = Locale(identifier: "fa_IR")
        }
        return formatter
    }
    
    private static func getDateFormatterWithStyle(calendar: Calendar.Identifier?, format: String?, dateStyle: DateFormatter.Style?, timeStyle: DateFormatter.Style?, isForSync: Bool) -> DateFormatter {
        let formatter = Date.getDateFormatter(calendar: calendar, isForSync: isForSync)
        if let format = format {
            formatter.dateFormat = format
        }
        if let dateStyle = dateStyle {
            formatter.dateStyle = dateStyle
        }
        if let timeStyle = timeStyle {
            formatter.timeStyle = timeStyle
        }
        return formatter
    }
    
    private static func getPersianDateFormatterWithStyle(format: String?, dateStyle: DateFormatter.Style?, timeStyle: DateFormatter.Style?) -> DateFormatter {
        return Date.getDateFormatterWithStyle(calendar: .persian, format: format, dateStyle: dateStyle, timeStyle: timeStyle, isForSync: false)
    }
        
    static func getPersianDate(from date: String) -> Date? {
        let formatter = Date.getDateFormatterWithStyle(calendar: .persian, format: "yyyy-MM-dd", dateStyle: nil, timeStyle: nil, isForSync: false)
        return formatter.date(from: date)
    }
    
    static func getTimeStampFormatDate(from date: String, isForSync: Bool) -> Date? {
        let formatter = Date.getDateFormatterWithStyle(calendar: nil, format: "yyyy-MM-dd HH:mm:ss.SSS", dateStyle: nil, timeStyle: nil, isForSync: isForSync)
        return formatter.date(from: date)
    }
    
    static func getDBFormatDate(from date: String, isForSync: Bool) -> Date? {
        let formatter = Date.getDateFormatterWithStyle(calendar: nil, format: "yyyy-MM-dd HH:mm:ss", dateStyle: nil, timeStyle: nil, isForSync: isForSync)
        return formatter.date(from: date)
    }
    
    //MARK: English Strings
//    func toTimeStampFormatDateAndTimeString(isForSync: Bool) -> String {
//        let formatter = Date.getDateFormatterWithStyle(calendar: nil, format: "yyyy-MM-dd HH:mm:ss.SSS", dateStyle: nil, timeStyle: nil, isForSync: isForSync)
//        return formatter.string(from: self)
//    }
    
    func toDBFormatDateAndTimeString(isForSync: Bool) -> String {
        let formatter = Date.getDateFormatterWithStyle(calendar: nil, format: "yyyy-MM-dd HH:mm:ss", dateStyle: nil, timeStyle: nil, isForSync: isForSync)
        return formatter.string(from: self)
    }
    
    func toDBFormatDateString() -> String {
        let formatter = Date.getDateFormatterWithStyle(calendar: nil, format: "yyyy-MM-dd", dateStyle: nil, timeStyle: nil, isForSync: false)
        return formatter.string(from: self)
    }
    
    func getHourString() -> String {
        let formatter = Date.getDateFormatterWithStyle(calendar: nil, format: "HH", dateStyle: nil, timeStyle: nil, isForSync: false)
        return formatter.string(from: self)
    }
    
    func getMinString() -> String {
        let formatter = Date.getDateFormatterWithStyle(calendar: nil, format: "mm", dateStyle: nil, timeStyle: nil, isForSync: false)
        return formatter.string(from: self)
    }
    
    //MARK: Persian Strings
    func toPersianTimeString() -> String { //13:10
        let hour = self.getHourString().convertEnglishNumToPersianNum().makeTwoDigitPersian()
        let min = self.getMinString().convertEnglishNumToPersianNum().makeTwoDigitPersian()
        return "\(hour):\(min)"
    }
    
    func toPersianWeekDMonth() -> String { // panjshanbe 15 aban
        return toPersianWeekDayString() + " " + toPersianDayString() + " " + toPersianMonthString()
    }
    
    func toPersianWeekDayString() -> String { // shanbe
        let formatter = Date.getPersianDateFormatterWithStyle(format: "EEEE", dateStyle: nil, timeStyle: nil)
        return formatter.string(from: self)
    }
    
    func toPersianDayString() -> String { // 15
        let formatter = Date.getPersianDateFormatterWithStyle(format: "dd", dateStyle: nil, timeStyle: nil)
        let str = formatter.string(from: self)
        if str[0] == "۰" {
            return str[1]
        }
        return str
    }
    
    func toPersianMonthString() -> String { // aban
        let formatter = Date.getPersianDateFormatterWithStyle(format: "MM", dateStyle: nil, timeStyle: nil)
        let monthNumber = formatter.string(from: self).convertPersianNumToEnglishNum()
        return formatter.monthSymbols[Int(monthNumber)! - 1]
    }
    
    func toPersianYearString() -> String { // 1399
        let formatter = Date.getPersianDateFormatterWithStyle(format: "yyyy", dateStyle: nil, timeStyle: nil)
        return formatter.string(from: self)
    }
    
    func toPersianShortString() -> String { // 99/8/15
        let formatter = Date.getPersianDateFormatterWithStyle(format: "yy/MM/dd", dateStyle: nil, timeStyle: nil)
        return formatter.string(from: self)
    }
    
    func toCompletePersianString() -> String { // 22 aban 1399, 20:14
        let formatter = Date.getPersianDateFormatterWithStyle(format: nil, dateStyle: .medium, timeStyle: .short)
        return formatter.string(from: self)
    }
    
    func toPersianDMonthYString() -> String { // 15 aban 1399
        let formatter = Date.getPersianDateFormatterWithStyle(format: nil, dateStyle: .medium, timeStyle: nil)
        return formatter.string(from: self)
    }
}
