//  SafeDispatch.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation

final public class SafeDispatch {
    
    private static let shared = SafeDispatch()
    
    private let mainQueueKey = DispatchSpecificKey<Int>()
    private let mainQueueValue = 1
    
    private init() {
        DispatchQueue.main.setSpecific(key: mainQueueKey, value: mainQueueValue)
    }
    
    
    public static func async(onQueue queue: DispatchQueue = .main, execute: @escaping () -> Void) {
        if queue === DispatchQueue.main {
            // If current on main queue.
            if DispatchQueue.getSpecific(key: shared.mainQueueKey) == shared.mainQueueValue {
                execute()
            } else {
                DispatchQueue.main.async(execute: execute)
            }
        } else {
            queue.async(execute: execute)
        }
    }
    
}
