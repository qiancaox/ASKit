//  UITextField+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UITextField {
    /// Check if text field is empty.
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}

public extension UITextField {
    
    /// Clear text and attributedText.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    
    /// Set placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    
    /// Add padding to the left of the textfield rect.
    func addLeftPadding(_ padding: CGFloat) {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: height)))
        view.backgroundColor = .clear
        leftView = view
        leftViewMode = .always
    }
    
    
    /// Add padding to the right of the textfield rect.
    func addRightPadding(_ padding: CGFloat) {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: height)))
        view.backgroundColor = .clear
        rightView = view
        rightViewMode = .always
    }
    
    
    /// Add padding to the left of the textfield rect by using image.
    /// - Parameters:
    ///   - image: Left image.
    ///   - padding: Amount of padding between icon and the left of textfield.
    func addLeftPadding(using image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: image.width + padding, height: image.height)))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        iconView.addSubview(imageView)
        leftView = iconView
        leftViewMode = .always
    }
    
    
    /// Add padding to the right of the textfield rect by using image.
    /// - Parameters:
    ///   - image: Right image.
    ///   - padding: Amount of padding between icon and the right of textfield.
    func addRightPadding(using image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: image.width + padding, height: image.height)))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        iconView.addSubview(imageView)
        rightView = iconView
        rightViewMode = .always
    }
}
