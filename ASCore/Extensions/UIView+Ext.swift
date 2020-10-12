//  UIView+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UIView {
    
    /// frame.size.width
    var width: CGFloat {
        get { frame.width }
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
    }
    /// frame.size.height
    var height: CGFloat {
        get { frame.height }
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
    }
    /// frame.origin.x
   var x: CGFloat {
        get { frame.minX }
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }
    /// frame.origin.y
    var y: CGFloat {
        get { frame.minY }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }
    /// frame.origin.x + frame.size.width
    var maxX: CGFloat {
        get { frame.maxX }
        set {
            var rect = frame
            rect.origin.x = newValue - rect.width
            frame = rect
        }
    }
    /// frame.origin.y + frame.size.height
    var maxY: CGFloat {
        get { frame.maxY }
        set {
            var rect = frame
            rect.origin.y = newValue - rect.height
            frame = rect
        }
    }
    /// frame.size
    var size: CGSize {
        get { frame.size }
        set { frame.size = newValue }
    }
    /// frame.origin
    var origin: CGPoint {
        get { frame.origin }
        set { frame.origin = newValue }
    }
    /// center.x
    var centerX: CGFloat {
        get { frame.midX }
        set { center.x = newValue }
    }
    /// center.y
    var centerY: CGFloat {
        get { frame.midY }
        set { center.y = newValue }
    }
    
}

public extension UIView {
    
    /// Create a snapshot image of the complete view hierarchy.
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
    
    /// Create a snapshot image of the complete view hierarchy.
    /// - It's faster than "snapshotImage", but may cause screen updates.
    /// - See UIView.drawHierarchy(in:afterScreenUpdates:) for more information.
    /// - Parameter afterUpdates: A Boolean value that indicates whether the snapshot should be
    ///  rendered after recent changes have been incorporated. Specify the value false if you
    ///   want to render a snapshot in the view hierarchy’s current state, which might not include recent changes.
    func snapshotImage(afterScreenUpdates afterUpdates: Bool) -> UIImage? {
        if !responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            return snapshotImage()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterUpdates)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap
    }
    
}

public extension UIView {
    
    
    /// Returns the view's view controller (may be nil).
    var viewController: UIViewController? {
        var view: UIView? = self
        while view != nil {
            guard let nextResponder = view!.next else { return nil }
            if nextResponder.isKind(of: UIViewController.self) {
                return nextResponder as? UIViewController
            }
            view = view!.superview
        }
        return nil
    }
}

public extension UIView {
    
    /// Make corner radius with special corners.
    /// - Should call this function after the frame is determined. Using `maskedCorners` in iOS11, so it's supported
    /// auto layout.
    /// - Parameters:
    ///   - cornerRadius: The radius of each corner oval. Values larger than half the rectangle’s width or height are
    ///   clamped appropriately to half the width or height.
    ///   - corners: A bitmask value that identifies the corners that you want rounded. You can use this parameter to
    ///    round only a subset of the corners of the rectangle.
    func setCornerRadius(_ cornerRadius: CGFloat, corners: UIRectCorner = .allCorners) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = cornerRadius;
            self.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let radii = CGSize(width: cornerRadius, height: cornerRadius)
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
    }
    
    
    /// Remove all subviews.
    func removeAllSubviews() {
        while subviews.count > 0 {
            subviews.last!.removeFromSuperview()
        }
    }
    
    
    /// Shortcut function of UIView to make shadow properties.
    /// - Parameters:
    ///   - color: Shadow color.
    ///   - offset: Shadow offset.
    ///   - radius: Shadow radius.
    ///   - opacity: Shadow opacity.
    ///   - path: Shadow path.
    func setShadow(withColor color: UIColor, offset: CGSize = .zero,
                          radius: CGFloat = 8, opacity: Float = 0,
                          path: CGPath? = nil) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowPath = path
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
}
