//  Touchable.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit
import ObjectiveC

/// Enable UILabel, UIImageView add .touchUpInside action.
public protocol Touchable {
    func addTarget(_ target: AnyObject, action: Selector)
}

extension UIImageView: Touchable {
    
    
    /// Add `touchuUpInside` event on UIImageView object.
    /// - Parameters:
    ///   - target: Responder for action.
    ///   - action: Respond action.
    public func addTarget(_ target: AnyObject, action: Selector) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer { [weak self] in
            if let tap = $0 as? UITapGestureRecognizer {
                if tap.state == .ended {
                    let view = tap.view
                    let location = tap.location(in: view)
                    if view?.bounds.contains(location) ?? false {
                        let _ = target.perform(action, with: self)
                    }
                }
            }
        }
        addGestureRecognizer(tapGesture)
    }
}

extension UILabel: Touchable {
    

    /// Add `touchuUpInside` event on UILabel object.
    /// - Parameters:
    ///   - target: Responder for action.
    ///   - action: Respond action.
    public func addTarget(_ target: AnyObject, action: Selector) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer { [weak self] in
            if let tap = $0 as? UITapGestureRecognizer {
                if tap.state == .ended {
                    let view = tap.view
                    let location = tap.location(in: view)
                    if view?.bounds.contains(location) ?? false {
                        let _ = target.perform(action, with: self)
                    }
                }
            }
        }
        addGestureRecognizer(tapGesture)
    }
}
