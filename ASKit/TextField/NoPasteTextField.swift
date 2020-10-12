//  NoPasteTextField.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

final public class NoPasteTextField: UITextField {
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        return false
    }
    
}
