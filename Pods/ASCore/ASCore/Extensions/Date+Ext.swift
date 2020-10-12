//  Date+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation

public extension Calendar.Component {
    
    
    /// All components.
    static func allComponents() -> Set<Calendar.Component> {
        return [.era, .year, .month, .day, .hour, .minute, .second, .weekday,
                .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear,
                .yearForWeekOfYear, .nanosecond, .calendar, .timeZone ]
    }
}

public extension Date {
    
    private static var dateComponentsAssociateKey = 0
    
    
    /// All components of date.
    var allComponents: DateComponents {
        guard let comps = objc_getAssociatedObject(self, &Date.dateComponentsAssociateKey) as? DateComponents else {
            let comps = Calendar.current.dateComponents(Calendar.Component.allComponents(), from: self)
            objc_setAssociatedObject(self, &Date.dateComponentsAssociateKey, comps, .OBJC_ASSOCIATION_RETAIN)
            return comps
        }
        return comps
    }
    
}

public extension Date {
    
    
    /// Returns a date parsed from given string interpreted using the format.
    /// If can not parse the date string, returns nil.
    /// - Parameters:
    ///   - string: The formated date string.
    ///   - format: The string's date format.
    /// - Returns: Date object represented by string
    static func date(from string: String, with format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}

public extension Date {
    
    var year: Int { allComponents.year! }
    var month: Int { allComponents.month! }
    var day: Int { allComponents.day! }
    var hour: Int { allComponents.hour! }
    var minute: Int { allComponents.minute! }
    var second: Int { allComponents.second! }
    /// Weekday component (1~7, first day is based on user setting).
    var weekday: Int { allComponents.weekday! }
    var isLeapMonth: Bool { allComponents.isLeapMonth! }
    var isLeapYear: Bool { ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))) }
    var isToday: Bool {
        if timeIntervalSinceNow >= 60 * 60 * 24 {
            return false
        }
        return Date().day == day
    }
    
}

public extension Date {
    
    
    /// Returns a date representing the receiver date shifted later by the provided
    /// number of days.
    /// - Parameter days: Number of days to add.
    func date(byAddingDays days: Int) -> Date? {
        var addingDateComponents = DateComponents()
        addingDateComponents.setValue(days, for: .day)
        return Calendar.current.date(byAdding: addingDateComponents, to: self)
    }
    
    
    /// Returns a date representing the receiver date shifted later by the provided
    /// number of months.
    /// - Parameter months  Number of months to add.
    func date(byAddingMonths months: Int) -> Date? {
        var addingDateComponents = DateComponents()
        addingDateComponents.setValue(months, for: .month)
        return Calendar.current.date(byAdding: addingDateComponents, to: self)
    }
    
    
    /// Returns a date representing the receiver date shifted later by the provided
    /// number of years.
    /// - Parameter months  Number of years to add.
    func date(byAddingYears years: Int) -> Date? {
        var addingDateComponents = DateComponents()
        addingDateComponents.setValue(years, for: .year)
        return Calendar.current.date(byAdding: addingDateComponents, to: self)
    }
    
    
    /// Returns a date representing the receiver date shifted later by the provided
    /// number of weeks.
    /// - Parameter months  Number of weeks to add.
    func date(byAddingWeeks weeks: Int) -> Date? {
        var addingDateComponents = DateComponents()
        addingDateComponents.setValue(weeks, for: .weekOfYear)
        return Calendar.current.date(byAdding: addingDateComponents, to: self)
    }
    
}

public extension Date {
    
    
    /// Get the string with formatted.
    /// - Parameter format: The formt string.
    func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
