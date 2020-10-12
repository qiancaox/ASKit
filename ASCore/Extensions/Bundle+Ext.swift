//  Bundle+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation

public extension Bundle {
    
    
    /// Get the bundle file named `name`.
    /// - Parameters:
    ///   - name: The bundle file's name.
    ///   - clazz: Class with the same path as the bundle file.
    /// - Returns: Bundle object of the bundle file.
    static func bundleFile(with name: String, targetClass clazz: AnyClass) -> Bundle {
        let bundle = Bundle(for: clazz)
        guard let url = bundle.url(forResource: name, withExtension: "bundle"),
              let result = Bundle(url: url) else {
            return .main
        }
        return result
    }
}
