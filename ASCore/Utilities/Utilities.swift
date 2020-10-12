//  Utilities.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

/// Convert degrees to radians.
public func Degrees2Radians(_ degrees: CGFloat) -> CGFloat {
    return degrees * CGFloat.pi / 180
}


/// Convert radians to degrees.
public func Radians2Degrees(_ radians: CGFloat ) -> CGFloat {
    return radians * 180 / CGFloat.pi
}


/// GCD execute closure on queue after delay.
public func DispatchAfterDelay(_ delay: DispatchTime, queue: DispatchQueue = .main, execute: @escaping () -> Void) {
    queue.asyncAfter(deadline: delay, execute: execute)
}


/// Color with r g b value and alpha.
public func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}


/// Color with h s b value and alpha.
public func HSB(_ h: CGFloat, _ s: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
    return UIColor(hue: h / 360.0, saturation: s / 100.0, brightness: b / 100.0, alpha: alpha)
}
