//  Calendar+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation

public extension Calendar {
    
    
    /// Get the number of days in the month for a specified `date`.
    /// - Parameter date: The date form which the number of days in month is calculated.
    /// - Returns: The number of days in the month of `date`.
    func numberOfDaysForMonth(with date: Date) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}
