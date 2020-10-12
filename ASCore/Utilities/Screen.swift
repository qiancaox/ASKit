//  Screen.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public struct Screen {
    
    /// Shortcut of UIScreen.main.
    public static let Main = UIScreen.main
    /// Shortcut of Screen.bounds.
    public static let Bounds = Main.bounds
    /// Shortcut of Screen.bounds.width.
    public static var Width: CGFloat {
        Main.bounds.width
    }
    /// Shortcut of Screen.bounds.width.
    public static var Height: CGFloat {
        Main.bounds.height
    }
    /// The height of naviagtion bar.
    public static let NaviagtionBarHeight: CGFloat = 44.0
    /// The height of tabBar.
    public static let TabBarHeight: CGFloat = 49.0
    
}
