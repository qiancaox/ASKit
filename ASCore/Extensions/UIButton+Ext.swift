//  UIButton+YSBasic.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UIButton {
    
    /// Using a color image to make a background image.
    /// - Parameters:
    ///   - color: The background image color.
    ///   - state: The state.
    func setBackgroundImage(using color: UIColor?, for state: UIControl.State) {
        let size = self.size == .zero ? CGSize(width: 1, height: 1) : self.size
        setBackgroundImage(UIImage.image(with: color ?? .clear, size: size),
                           for: state)
    }
    
    
    /// Vertical align title text and image.
    /// Refer: https://stackoverflow.com/questions/2451223/
    /// - Parameters:
    ///   - spacing: spacing between title text and image.
    func alignVertical(spacing: CGFloat) {
        guard let imageSize = imageView?.image?.size,
              let text = titleLabel?.text,
              let font = titleLabel?.font else {
            return
        }
        
        titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageSize.width,
            bottom: -(imageSize.height + spacing),
            right: 0.0
        )

        let titleSize = text.size(withAttributes: [.font: font])
        imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + spacing),
            left: 0.0,
            bottom: 0.0,
            right: -titleSize.width
        )

        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        contentEdgeInsets = UIEdgeInsets(
            top: edgeOffset,
            left: 0.0,
            bottom: edgeOffset,
            right: 0.0
        )
    }
    
}
