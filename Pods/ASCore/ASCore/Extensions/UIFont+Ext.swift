//  UIFont+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UIFont {
    
    /// PingFangSC font family names.
    enum PingFangSC: String {
        case Medium     = "PingFangSC-Medium"
        case Semibold   = "PingFangSC-Semibold"
        case Light      = "PingFangSC-Light"
        case Ultralight = "PingFangSC-Ultralight"
        case Regular    = "PingFangSC-Regular"
        case Thin       = "PingFangSC-Thin"
    }
    
    convenience init(PingFangSC name: PingFangSC, size: CGFloat) {
        self.init(name: name.rawValue, size: size)!
    }
    
}
