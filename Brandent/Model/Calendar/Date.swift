//
//  Date.swift
//  Brandent
//
//  Created by Sara Babaei on 11/20/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation

extension Date {
    public var currentCalendar: Calendar {
        
        var locale: Locale!
        
        if let localeString = UserDefaults.standard.object(forKey: "current_locale") as? String {
            locale = Locale(identifier: localeString)
        } else {
            locale = Locale.current
        }
        return locale.calendar
    }
    
    public var today: Date {
        let comps: DateComponents = currentCalendar.dateComponents([.year, .month, .weekOfMonth, .day], from: self)
        return currentCalendar.date(from: comps)!
    }
    
    public var startingDayOfWeek: Int{
        return currentCalendar.component(.weekday, from: self)
    }
    
    public var startDayOfWeek: Date{
        var firstDayOfWeek = currentCalendar.date(from: currentCalendar.dateComponents([.year, .month, .weekOfYear], from: currentCalendar.startOfDay(for: self)))! //of year or month?
        while firstDayOfWeek.componentsOfDate.week != currentCalendar.startOfDay(for: self).componentsOfDate.week {
            firstDayOfWeek = currentCalendar.date(byAdding: .day, value: 1, to: firstDayOfWeek)!
        }
        return firstDayOfWeek
    }
    
    public var endDayOfWeek: Date{
        return currentCalendar.date(byAdding: DateComponents(day: 7), to: startDayOfWeek)!
    }
    
    public func date(year: Int, month: Int, day: Int) -> Date{
        var comps: DateComponents = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        
        return currentCalendar.date(from: comps)!
    }
    
    public var daysIntWeek: Int{
        return currentCalendar.range(of: .day, in: .weekOfMonth, for: self)!.count
    }
    
    public var componentsOfDate: (year: Int, month: Int, day: Int, week: Int, weekDay: Int){
        let comps = currentCalendar.dateComponents([.year, .month, .day, .weekOfMonth, .weekday], from: self)
        return (comps.year!, comps.month!, comps.day!, comps.weekOfMonth!, comps.weekday!)
    }
    
    public var nextWeek: Date{
        return currentCalendar.date(byAdding: DateComponents(weekOfMonth: 1), to: self)!
    }
    
    public var previousWeek: Date{
        return currentCalendar.date(byAdding: DateComponents(weekOfMonth: -1), to: self)!
    }
    
    public var monthName: String{
        let dtFormatter: DateFormatter = DateFormatter()
        dtFormatter.dateFormat = "MMMM"
        dtFormatter.locale = currentCalendar.locale
        
        return dtFormatter.string(from: self)
    }
    
    public var dayName: String{
        let dtFormatter: DateFormatter = DateFormatter()
        dtFormatter.dateFormat = "EEEE"
        dtFormatter.locale = currentCalendar.locale
        
        return dtFormatter.string(from: self)
    }
    
    public func isToday(date: Date) -> Bool{
        let result = currentCalendar.compare(self, to: date, toGranularity: .day)
        switch result{
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    public var daysVeryShort: [String]{
        return currentCalendar.veryShortWeekdaySymbols
    }
    
    public var days: [String]{
        return currentCalendar.shortWeekdaySymbols
    }
    
    public var months: [String]{
        return currentCalendar.monthSymbols
    }
    
    public func add(days: Int) -> Date{
        return currentCalendar.date(byAdding: .day, value: days, to: self)!
    }

    public func add(months: Int) -> Date{
        return currentCalendar.date(byAdding: .month, value: months, to: self)!
    }
    
    public func isInSameDay(date: Date) -> Bool {
        return date.componentsOfDate.year == self.componentsOfDate.year &&
            date.componentsOfDate.month == self.componentsOfDate.month &&
            date.componentsOfDate.day == self.componentsOfDate.day
    }
    
    public func isInSameMonth(date: Date) -> Bool {
        return date.componentsOfDate.year == self.componentsOfDate.year &&
            date.componentsOfDate.month == self.componentsOfDate.month
    }
}
