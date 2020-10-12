//  UINavigationController+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UINavigationController {
    
    /// Pop ViewController with completion handler.
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition, defaults to true.
    ///   - completion: Optional completion handler, defaults to nil.
    func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    
    /// Push ViewController with completion handler.
    /// - Parameters:
    ///   - viewController: ViewController to push.
    ///   - completion: Optional completion handler, defaults to nil.
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    
    /// Make navigation controller's navigation bar transparent.
    /// - Parameter tint: Tint color, defaults to white.
    func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
    
}
