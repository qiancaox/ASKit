//  UIWindow+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UIWindow {
    
    
    /// Change current root view controller with a new view controller.
    /// - Parameters:
    ///   - viewController: New root view controller.
    ///   - animated: Set to true to animate view controller change, defaults to true.
    ///   - duration: Animation duration in seconds, defaults to 0.3.
    ///   - options: Animation options, defaults to transitionFlipFromRight.
    ///   - completion: Optional completion handler called after view controller is changed.
    func changeRootViewController(to viewController: UIViewController, animated: Bool = true,
                                    duration: TimeInterval = 0.3,
                                    options: UIView.AnimationOptions = .transitionFlipFromRight,
                                    _ completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            completion?()
            return
        }

        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
}
