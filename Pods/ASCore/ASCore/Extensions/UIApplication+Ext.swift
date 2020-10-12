//  UIApplication+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension Screen {
    
    /// Shortcut of UIApplication.statusBarFrame().height.
    static var StatusBarHeight: CGFloat {
        UIApplication.statusBarFrame().height
    }
    /// Shortcut of UIApplication.safeAreaInsets()
    static var SafeArea: UIEdgeInsets {
        UIApplication.safeAreaInsets()
    }
    
}

public extension UIApplication {
    
    /// Get the all UIWindowScene instances connected with shared application.
    @available(iOS 13, *) static func windowSecens() -> [UIWindowScene] {
        return UIApplication.shared.connectedScenes
            .map { $0 as? UIWindowScene } // Only UIWindowScene instance.
            .compactMap { $0 } // Filter nil object.
    }
    
    
    /// Status bar frame.
    static func statusBarFrame() -> CGRect {
        if #available(iOS 13, *) {
            let windowScene = windowSecens()
            // Get the only scene's statusBarManager
            guard let statusBarManager = windowScene.first?.statusBarManager else {
                return .zero // If not exist, return zero.
            }
            return statusBarManager.statusBarFrame
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }
    
    
    /// The safe area insets.
    static func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 13, *) {
            let windowScene = windowSecens()
            // Get the only window from scene.
            guard let window = windowScene.first?.windows.first else {
                return .zero // If not exist, return zero.
            }
            return window.safeAreaInsets
        } else {
            if #available(iOS 11, *) {
                return UIApplication.shared.keyWindow!.safeAreaInsets
            } else {
                if Device.isFullScreen() {
                    return UIEdgeInsets(top: 44.0, left: 0, bottom: 34.0, right: 0)
                }
                return .zero
            }
        }
    }
    
}

public extension UIApplication {
    
    
    /// Get current displayed view controller.
    static func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        print(File.Caches)
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
