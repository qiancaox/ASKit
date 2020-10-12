//  UIImage+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit
import QuartzCore

public extension UIImage {
    
    /// Shortcut of size.width.
    var width: CGFloat { size.width }
    /// Shortcut of size.height.
    var height: CGFloat { size.height }
    
}

public extension UIImage {
    
    /// Returns a new rotated image (relative to the center).
    /// - Parameters:
    ///   - radians: Rotated radians in counterclockwise.⟲
    ///   - fitSize: YES: new image's size is extend to fit all content.
    ///   NO: image's size will not change, content may be clipped.
    func imageRotated(with radians: CGFloat, fitSize: Bool = true) -> UIImage? {
        guard let _ = cgImage else {
            fatalError("UIImage+Transform error when calling imageByRotate(forRadians:fitSize:): inputImage must be backed by a cgImage.")
        }
        
        let width = cgImage!.width
        let height = cgImage!.height
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        let applyingTransform = fitSize ? CGAffineTransform(rotationAngle: radians) : .identity
        let newRect = rect.applying(applyingTransform)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageByteOrderInfo.orderDefault.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let context = CGContext(data: nil, width: Int(newRect.width), height: Int(newRect.height),
                                      bitsPerComponent: 8, bytesPerRow: Int(newRect.width) * 4,
                                      space: colorSpace, bitmapInfo: bitmapInfo)
            else  {
            return nil
        }
        
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        context.interpolationQuality = .high
        
        context.translateBy(x: newRect.width * 0.5, y: newRect.height * 0.5)
        context.rotate(by: radians)
        
        context.draw(cgImage!, in: CGRect(x: -width / 2, y: -height / 2, width: width, height: height))
        guard let imageRef = context.makeImage() else { return nil }
        let image = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return image
    }
    
    
    /// Returns a new image which is scaled from this image. The image will be stretched as needed.
    /// - Parameter size: The new size to be scaled, values should be positive.
    /// - Returns: The new image with the given size.
    func imageResized(to size: CGSize) -> UIImage? {
        if size.width == 0 || size.height == 0 {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// Image ratated left 90 degrees.
    func rotateLeft90() -> UIImage? {
        return imageRotated(with: Degrees2Radians(-90))
    }
    
    
    /// Image ratated right 90 degrees.
    func rotateRight90() -> UIImage? {
        return imageRotated(with: Degrees2Radians(90))
    }
    
}

public extension UIImage {
    
    /// Create and return a pure color image with the given color and size.
    /// - If size contains 0, returned nil.
    /// - Parameters:
    ///   - color: The color.
    ///   - size: New image's size. Defaults to (1, 1).
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        if size.width == 0 || size.height == 0 { return nil }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// Rounds a new image with a given corner size.
    /// - Parameters:
    ///   - radius: The radius of each corner oval. Values larger than half the
    ///   rectangle's width or height are clamped appropriately to
    ///   half the width or height.
    ///   - corners: A bitmask value that identifies the corners that you want
    ///   rounded. You can use this parameter to round only a subset
    ///   of the corners of the rectangle.
    ///   - borderWidth: The inset border line width. Values larger than half the rectangle's
    ///   width or height are clamped appropriately to half the width or height.
    ///   - borderColor: The border stroke color. nil means clear color.
    func imageRounded(with radius: CGFloat, corners: UIRectCorner = .allCorners,
                      borderWidth: CGFloat = 0, borderColor: UIColor? = nil) -> UIImage? {
        guard let _ = cgImage else {
            fatalError("UIImage+Color error when calling imageByRound(withCornerRadius:corners:borderWidth:borderColor:): inputImage must be backed by a cgImage.")
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        let rect = CGRect(origin: .zero, size: size)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)
        
        let minSize = min(width, height)
        if borderWidth < minSize / 2 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: borderWidth))
            path.close()
            
            context.saveGState()
            path.addClip()
            context.draw(cgImage!, in: rect)
            context.restoreGState()
        }
        
        if borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0 {
            let strokeInset = (floor(borderWidth * scale) + 0.5) / scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > scale / 2 ? radius - scale / 2 : 0
            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            path.close()
            
            path.lineWidth = borderWidth
            path.lineJoinStyle = .miter
            borderColor!.setStroke()
            path.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// Create a new image which masked by color.
    /// - Parameters:
    ///   - color: The masked color.
    ///   - fraction: A tinted fraction mask of the image.
    /// - Returns: The new image.
    func imageTint(by color: UIColor, fraction: CGFloat = 0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let rect = CGRect(origin: .zero, size: size)
        color.set()
        UIRectFill(rect)
        draw(in: rect, blendMode: .destinationIn, alpha: 1)
        if fraction > 0 {
            draw(in: rect, blendMode: .sourceAtop, alpha: fraction)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
}
