//  Array+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}


/// Subtract the result set whose value is equal to second from the first array.
/// - Parameters:
///   - first: The original array being subtracted.
///   - second: The value to subtract from the array.
/// - Returns: The result set after subtraction.
@inlinable public func - <Item> (first: [Item], second: Item) -> [Item]
                  where Item: Equatable
{
    var result = [Item] ()
    first.forEach {
        if $0 != second {
            result.append($0)
        }
    }
    return result
}


/// Subtract and assign.
@inlinable public func -= <Item> (first: inout [Item], second: Item)
                  where Item: Equatable
{
    first = first - second
}
