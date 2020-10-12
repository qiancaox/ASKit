//  UIScrollView+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UIScrollView {
    
    func scrollToTop(animated: Bool = true) {
        var offset = contentOffset
        offset.y = 0 - contentInset.top
        setContentOffset(offset, animated: animated)
    }
    
    
    func scrollToBottom(animated: Bool = true) {
        var offset = contentOffset
        offset.y = max(contentSize.height - bounds.height + contentInset.bottom, 0)
        setContentOffset(offset, animated: animated)
    }
    
    
    func scrollToRight(animated: Bool = true) {
        var offset = contentOffset
        offset.x = max(contentSize.width - bounds.width + contentInset.right, 0)
        setContentOffset(offset, animated: animated)
    }
    
    
    func scrollToLeft(animated: Bool = true) {
        var offset = contentOffset
        offset.x = 0 - contentInset.left
        setContentOffset(offset, animated: animated)
    }
    
}
