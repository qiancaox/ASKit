//  UIAlertController+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UIAlertController {
    
    /// Show alert from view controller.
    static func alert(from viewController: UIViewController? = UIApplication.topViewController(),
                             title: String? = nil, message: String? = nil,
                             cancelTitle: String?,
                             actionTitles: [String]?, action block: ((Int) -> Void)?) {
        alertController(from: viewController, title: title, message: message, cancelTitle: cancelTitle,
                        preferredStyle: .alert, actionTitles: actionTitles, action: block)
    }
    
    
    /// Show actionSheet from view controller.
    static func actionSheet(from viewController: UIViewController? = UIApplication.topViewController(),
                                   title: String? = nil, message: String? = nil,
                                   cancelTitle: String?,
                                   actionTitles: [String]?, action block: ((Int) -> Void)?) {
        alertController(from: viewController, title: title, message: message, cancelTitle: cancelTitle,
                        preferredStyle: .actionSheet, actionTitles: actionTitles, action: block)
    }
    
    
    /// Show alert controller from view controller.
    static func alertController(from viewController: UIViewController?,
                                       title: String?, message: String?,
                                       cancelTitle: String?, preferredStyle style: UIAlertController.Style,
                                       actionTitles: [String]?, action block: ((Int) -> Void)?) {
        guard let _ = viewController else {
            fatalError("UIAlertController+Common error: alert could not presented from a nil view controller.")
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if cancelTitle != nil {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        
        if actionTitles != nil && actionTitles!.count > 0 {
            for i in 0..<actionTitles!.count {
                let title = actionTitles![i]
                let action = UIAlertAction(title: title, style: .default) { _ in
                    if block != nil {
                        block!(i)
                    }
                }
                alertController.addAction(action)
            }
        }
        
        viewController!.present(alertController, animated: true, completion: nil)
    }
    
}
