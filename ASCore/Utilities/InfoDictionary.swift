//  InfoDictionary.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation

public struct InfoDictionary {
    
    /// Application's Bundle ID. e.g. "com.xqc.Test".
    public static let BundleID = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    /// Application's Version. e.g. "1.2.0".
    public static let Version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    /// Application's Build number. e.g. "123".
    public static let Build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    /// Application's Bundle Name (show in SpringBoard).
    public static let Name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
   
}
