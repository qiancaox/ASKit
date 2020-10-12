//  File.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation

public struct File {
    
    /// Shortcut of FileManager.default.
    public static let Manager = FileManager.default
    /// "Documents" folder in this app's sandbox.
    public static let Doucument = Manager.urls(for: .documentDirectory, in: .userDomainMask).last!
    public static let DoucumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    /// "Caches" folder in this app's sandbox.
    public static let Caches = Manager.urls(for: .cachesDirectory, in: .userDomainMask).last!
    public static let CachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
    /// "Library" folder in this app's sandbox.
    public static let Library = Manager.urls(for: .libraryDirectory, in: .userDomainMask).last!
    public static let LibraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last!
    
    /// Save string in `Doucument` with file name.
    /// - Parameters:
    ///   - json: The saved string.
    ///   - name: The file name.
    /// - Throws: The error when string write to file.
    public static func save(_ string: String, fileName name: String) throws {
        let saveURL = Doucument.appendingPathComponent(name)
        do {
            try string.write(to: saveURL, atomically: true, encoding: .utf8)
        } catch {
            throw error
        }
    }
    
    
    /// Get saved string in file with name.
    /// - Parameter fileName: The saved string file name.
    /// - Throws: The error when get string form file.
    /// - Returns: The contents string in file.
    public static func stringFromFile(with fileName: String) throws -> String {
        let saveURL = Doucument.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: saveURL)
            let string = String(data: data, encoding: .utf8)
            return string ?? ""
        } catch {
            throw error
        }
    }
    
    
    /// File exists at path.
    public static func fileExists(atPath path: String) -> Bool {
        return Manager.fileExists(atPath: path)
    }
    
}
