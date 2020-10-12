//  UIColor+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UIColor {
    
    /// Color from hex string.
    /// - Parameters:
    ///   - hexString: The rgb string such as `'0x456FFB'` or `'#456FFB'` strings.
    ///   - alpha: The alpha value of color. Defaults to 1.
    convenience init(_ hexString: String, alpha: CGFloat = 1) {
        let hexString = hexString.trimed().uppercased()
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        } else if hexString.hasPrefix("0X") {
            scanner.scanLocation = 2
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    /// Color from hex string.
    /// - Parameters:
    ///   - rgbValue: The rgb value such as `0x456FFB` hex.
    ///   - alpha: The alpha value of color. Defaults to 1.
    convenience init(_ rgbValue: Int32, alpha: CGFloat = 1) {
        self.init(red: CGFloat(((rgbValue & 0xFF0000) >> 16)) / 255.0,
                  green: CGFloat(((rgbValue & 0xFF00) >> 8)) / 255.0,
                  blue: CGFloat((rgbValue & 0xFF)) / 255.0, alpha: alpha)
    }
    
}

public extension UIColor {
    
    /// Returns mixed color whitin two colors in a certain ratio.
    /// - Parameters:
    ///   - color: The another mixed color.
    ///   - rate: The rate of mixed progress.
    func blend(with color: UIColor, rate: CGFloat) -> UIColor {
        let rate = min(1, max(0, rate))
        let r0 = red(), g0 = green(), b0 = blue(), a0 = alpha()
        let r1 = color.red(), g1 = color.red(), b1 = color.blue(), a1 = color.alpha()
        let r = r1 * rate + r0 * (1 - rate), g =  g1 * rate + g0 * (1 - rate), b = b1 * rate + b0 * (1 - rate)
        let a = a1 * rate + a0 * (1 - rate)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    /// Generate a color which covered another color on current color.
    /// - Parameters:
    ///   - top: The cover color.
    ///   - alpha: The cover alpha.
    func covered(with color: UIColor, alpha: CGFloat) -> UIColor {
        let a = min(1, max(0, alpha))
        let r0 = red(), g0 = green(), b0 = blue()
        let r1 = color.red(), g1 = color.red(), b1 = color.blue()
        let r = (1 - a) * r0 + a * r1, g = (1 - a) * g0 + a * g1, b = (1 - a) * b0 + a * b1
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
}

public extension UIColor {
    
    /// The red component of color.
    func red() -> CGFloat {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    
    
    /// The blue component of color.
    func green() -> CGFloat {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    
    
    /// The blue component of color.
    func blue() -> CGFloat {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    
    
    /// The alpha component of color.
    func alpha() -> CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    
    /// The hue component of color.
    func hue() -> CGFloat {
        var h: CGFloat = 0
        getHue(&h, saturation: nil, brightness: nil, alpha: nil)
        return h
    }
    
    
    /// The saturation component of color.
    func saturation() -> CGFloat {
        var s: CGFloat = 0
        getHue(nil, saturation: &s, brightness: nil, alpha: nil)
        return s
    }
    
    
    /// The brightness component of color.
    func brightness() -> CGFloat {
        var b: CGFloat = 0
        getHue(nil, saturation: nil, brightness: &b, alpha: nil)
        return b
    }
    
}
