//  Toast.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit
import SnapKit
import ObjectiveC
import ASCore

let ResBundle = Bundle.bundleFile(with: "Resource", targetClass: Toast.self)

public final class Toast {
    
    /// Location of the Toast in super view.
    public enum Location {
        case top, center, bottom
    }
    
    public struct Apperance {
        
        /// The color of activity and text.
        public var color = UIColor(white: 0.914, alpha: 0.973)
        
        /// The color of content.
        public var foregroundColor = UIColor(white: 0.156, alpha: 0.823)
        
    }
    
    private static let shared = Toast()
    
    private init() {
    }
    
    /// Show toast in window with text at location, dismiss after delay.
    /// - Parameters:
    ///   - text: The text of toast.
    ///   - location: The location of toast in view.
    ///   - delay: Dismiss after delay.
    public static func show(text: String, atLocation location: Location = .center,
                     hideAfterDelay delay: TimeInterval = 2.58) {
        // text must more than one word.
        if text.count == 0 {
            return
        }
        
        SafeDispatch.async {
            let view = shared.ToastForText(text, atLocation: location)
            shared.showView(view, animated: true)
            shared.hideView(view, afterDelay: delay)
        }
    }
    
}


// MARK: - Apperance

public extension Toast {
    
    /// Customize static property before using Toast.
    static var apperance = Apperance()
    
}


// MARK: - Implemetations

fileprivate extension Toast {
    
    /// Create a Toast in view.
    @discardableResult
    private func ToastForText(_ text: String, atLocation location: Location) -> UIView {
        // Toast content view.
        let contentView = UIView()
        contentView.isUserInteractionEnabled = false
        contentView.layer.cornerRadius = 2
        contentView.alpha = 0
        contentView.setShadow(withColor: Toast.apperance.foregroundColor, offset: .zero, radius: 4, opacity: 0.2)
        contentView.backgroundColor = Toast.apperance.foregroundColor
        Application.KeyWindow.addSubview(contentView)
        contentView.snp.makeConstraints {
            switch location {
            case .center:
                $0.centerY.equalToSuperview()
            case .top:
                $0.top.equalTo(Screen.SafeArea.top + 20)
            case .bottom:
                $0.bottom.equalTo(-Screen.SafeArea.bottom + -20)
            }
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualTo(18)
        }
        
        // HUD text in content view.
        let label = UILabel()
        label.numberOfLines = 6
        label.textAlignment = .center
        label.font = UIFont(PingFangSC: .Regular, size: 14)
        label.textColor = Toast.apperance.color
        label.text = text
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualTo(10)
            $0.right.equalTo(-12)
        }
        
        return contentView
    }
    
    /// Show toast view with animated.
    private func showView(_ view: UIView, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.1, delay: 0, options: .init(rawValue: 0), animations: {
                view.alpha = 1
            }) { _ in
                
            }
        } else {
            view.alpha = 1
        }
    }
    
    /// Hide toast view after delay.
    private func hideView(_ view: UIView, afterDelay delay: TimeInterval) {
        let graceTimer = Timer(timeInterval: delay, target: self,
                               selector: #selector(handleHideTimer(_:)),
                               userInfo: view, repeats: false)
        RunLoop.current.add(graceTimer, forMode: .common)
    }
    
    // MARK: - Handle Timer
    
    @objc
    private func handleHideTimer(_ timer: Timer) {
        let view = timer.userInfo as! UIView
        timer.invalidate()
        UIView.animate(withDuration: 0.1, delay: 0, options: .init(rawValue: 0), animations: {
            view.alpha = 0
        }) { _ in
            view.removeFromSuperview()
        }
    }
    
}
