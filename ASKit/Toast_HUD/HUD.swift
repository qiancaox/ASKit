//  HUD.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit
import SnapKit
import ObjectiveC
import ASCore

public final class HUD {

    public enum Status: CustomStringConvertible {
        
        case success, error
        
        public var description: String {
            switch self {
            case .success:
                return "Success!"
            default:
                return "Error!"
            }
        }
        
    }
    
    public enum ActivityType {
        case system, ring
    }
    
    public struct Apperance {
        
        /// The color of activity and text.
        public var color = UIColor(white: 0.914, alpha: 0.973)
        
        /// The color of content.
        public var foregroundColor = UIColor(white: 0.156, alpha: 0.823)
        
        /// The color of background only effect in `HUD`.
        public var backgroundColor = UIColor.clear
        
        /// If the task finishes before the grace time runs out, the HUD will
        /// not be shown at all. only effect in `HUD`.
        public var graceTime: TimeInterval = 0.14
        
        /// The activity indicator type.
        public var type: ActivityType = .system
        
    }
    
    private static let shared = HUD()
    
    private init() {
    }
    
    /// Show Loading HUD in view with text.
    /// - Parameters:
    ///   - view: Super view of HUD will shown.
    ///   - text: The notice text HUD will show.
    ///   - blockingUI: Can user touched accross the HUD.
    public static func show(inView view: UIView = Application.KeyWindow, text: String? = nil, blockingUI: Bool = true) {
        SafeDispatch.async {
            let view = shared.HUDForView(view, text: text ?? "Loading...", blockingUI: blockingUI)
            shared.showView(view)
        }
    }
    
    /// Hide HUD in view.
    /// - Parameter view: Super view of HUD will shown.
    public static func hide(inView view: UIView = Application.KeyWindow) {
        SafeDispatch.async {
            if let first = shared.firstHUDForView(view) {
                // Set finished.
                objc_setAssociatedObject(first, &kHUDFinished, true, .OBJC_ASSOCIATION_ASSIGN)
                shared.hideView(first)
            }
        }
    }
    
    /// Change activity to state using image.
    /// - Parameters:
    ///   - view: Super view of HUD will shown.
    ///   - text: The notice text HUD will show.
    ///   - status: The status will changed to.
    ///   - blockingUI: Can user touched accross the HUD.
    ///   - delay: Hide after delay.
    public static func state(inView view: UIView = Application.KeyWindow, text: String? = nil,
                      status: Status, blockingUI: Bool = true,
                      hideAfterDelay delay: TimeInterval = 2.58) {
        // Can not change state.
        if delay <= apperance.graceTime {
            return
        }
        
        SafeDispatch.async {
            // Get HUD view if not have add a new HUD.
            var hudView: UIView
            if let first = shared.firstHUDForView(view) {
                hudView = first
                hudView.isUserInteractionEnabled = blockingUI
            } else {
                hudView = shared.HUDForView(view, text: text ?? status.description,
                                            blockingUI: blockingUI)
                shared.showView(hudView)
            }
            
            // Change stata.
            shared.changeActvityToState(status, text: text ?? status.description, forView: hudView)
            
            // Hide after delay.
            shared.hideView(hudView, afterDelay: delay)
        }
    }
    
}


// MARK: - Apperance

public extension HUD {
    
    /// Customize static property before using HUD.
    static var apperance = Apperance()
    
}


// MARK: - Implemetations

fileprivate extension HUD {
    
    private struct ContentSubviewTags {
        static let content = 10000
        static let label = 10001
        static let activity = 10002
        static let imageView = 10003
    }
    
    /// Create a HUD in view.
    @discardableResult
    private func HUDForView(_ view: UIView, text: String, blockingUI: Bool) -> UIView {
        // HUD container view.
        let containerView = UIView(frame: view.bounds)
        objc_setAssociatedObject(containerView, &HUDIdentifier.key, HUDIdentifier.value, .OBJC_ASSOCIATION_COPY)
        objc_setAssociatedObject(containerView, &HUD.kHUDFinished, false, .OBJC_ASSOCIATION_ASSIGN)
        containerView.isUserInteractionEnabled = blockingUI
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // HUD content view.
        let contentView = UIView()
        contentView.layer.cornerRadius = 2
        contentView.tag = ContentSubviewTags.content
        contentView.alpha = 0
        contentView.transform = contentView.transform.scaledBy(x: 0.92, y: 0.92)
        contentView.setShadow(withColor: HUD.apperance.foregroundColor, offset: .zero, radius: 4, opacity: 0.2)
        contentView.backgroundColor = HUD.apperance.foregroundColor
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.greaterThanOrEqualTo(18)
        }
        
        // HUD Activity in content view.
        var activity: UIView
        if case .system = HUD.apperance.type {
            activity = UIActivityIndicatorView(style: .white)
            (activity as! UIActivityIndicatorView).color = HUD.apperance.color
        } else {
            activity = HUDActivityIndicator()
            (activity as! HUDActivityIndicator).color = HUD.apperance.color
        }
        activity.tag = ContentSubviewTags.activity
        contentView.addSubview(activity)
        (activity as! _ActivityIndicator).startAnimating()
        activity.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualTo(10)
        }
        
        // HUD text in content view.
        let label = UILabel()
        label.numberOfLines = 1
        label.tag = ContentSubviewTags.label
        label.font = UIFont(PingFangSC: .Regular, size: 14)
        label.textColor = HUD.apperance.color
        label.text = text
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalTo(activity.snp_right).offset(8)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualTo(10)
            $0.right.equalTo(-12)
        }
        
        // Add image view.
        let imageView = UIImageView()
        imageView.tag = ContentSubviewTags.imageView
        imageView.isHidden = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.size.equalTo(activity)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(activity.snp_left)
        }
        
        return containerView
    }
    
    /// Show view with grace time managed.
    private func showView(_ view: UIView) {
        if HUD.apperance.graceTime > 0 {
            let graceTimer = Timer(timeInterval: HUD.apperance.graceTime,
                                   target: self, selector: #selector(handleGraceTimer(_:)),
                                   userInfo: view, repeats: false)
            RunLoop.current.add(graceTimer, forMode: .common)
        } else {
            showView(view, animated: true)
        }
    }
    
    /// Show hud view with animated.
    private func showView(_ view: UIView, animated: Bool) {
        let contentView = view.viewWithTag(ContentSubviewTags.content)!
        let showImpl = {
            view.backgroundColor = HUD.apperance.backgroundColor
            contentView.alpha = 1
            contentView.transform = .identity
        }
        if animated {
            UIView.animate(withDuration: 0.1, delay: 0, options: .init(rawValue: 0), animations: {
                showImpl()
            }) { _ in
                
            }
        } else {
            showImpl()
        }
    }
    
    /// Hide view.
    private func hideView(_ view: UIView) {
        let contentView = view.viewWithTag(ContentSubviewTags.content)!
        UIView.animate(withDuration: 0.1, delay: 0, options: .init(rawValue: 0), animations: {
            view.backgroundColor = .clear
            contentView.alpha = 0
            contentView.transform = contentView.transform.scaledBy(x: 0.92, y: 0.92)
        }) { _ in
            view.removeFromSuperview()
        }
    }
    
    /// Hide view after delay.
    private func hideView(_ view: UIView, afterDelay delay: TimeInterval) {
        let hideTimer = Timer(timeInterval: delay, target: self,
                              selector: #selector(handleHideTimer(_:)),
                              userInfo: view, repeats: false)
        RunLoop.current.add(hideTimer, forMode: .common)
    }
    
    /// Change activity to state.
    private func changeActvityToState(_ status: Status, text: String, forView view: UIView) {
        let activity = view.viewWithTag(ContentSubviewTags.activity) as! _ActivityIndicator
        activity.stopAnimating()
        let label = view.viewWithTag(ContentSubviewTags.label) as! UILabel
        label.text = text
        
        let imageView = view.viewWithTag(ContentSubviewTags.imageView) as! UIImageView
        var image: UIImage?
        switch status {
        case .error:
            image = UIImage(named: "icon_HUD_error", in: ResBundle, compatibleWith: nil)
        case .success:
            image = UIImage(named: "icon_HUD_success", in: ResBundle, compatibleWith: nil)
        }
        imageView.image = image
        imageView.isHidden = false
    }
    
    // MARK: - Helpers
    
    /// Get hud which top of the hud added in view.
    private func firstHUDForView(_ view: UIView) -> UIView? {
        let views = view.subviews.filter { subview -> Bool in
            let identifier = objc_getAssociatedObject(subview, &HUDIdentifier.key) as? String
            if identifier == HUDIdentifier.value {
                return true
            }
            return false
        }.reversed()
        return views.first
    }
    
    // MARK: - Handle Timer
    
    @objc
    private func handleGraceTimer(_ timer: Timer) {
        let view = timer.userInfo as! UIView
        timer.invalidate()
        let finished = objc_getAssociatedObject(view, &HUD.kHUDFinished) as! Bool
        if !finished {
            showView(view, animated: true)
        }
    }
    
    @objc
    private func handleHideTimer(_ timer: Timer) {
        let view = timer.userInfo as! UIView
        objc_setAssociatedObject(view, &HUD.kHUDFinished, true, .OBJC_ASSOCIATION_ASSIGN)
        timer.invalidate()
        hideView(view)
    }
    
}


// MARK: - Associate Keys

fileprivate extension HUD {
    
    // The hud identifier in subviews.
    private struct HUDIdentifier {
        static var key = 0
        static let value = "YSBasics_HUD_HUDIdentifier_Value"
    }
    
    // Storage the finishe state for hud.
    private static var kHUDFinished = "HUD_Finished"
    
}


// MARK: - HUD Activity Indicator

fileprivate protocol _ActivityIndicator {
    func startAnimating()
    func stopAnimating()
}

extension UIActivityIndicatorView: _ActivityIndicator {
}

fileprivate class HUDActivityIndicator: UIView, _ActivityIndicator {
    
    var color: UIColor! {
        didSet {
            shapeLayer.strokeColor = color.cgColor
        }
    }
    
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = .round
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: 10, y: 10),
                                       radius: 9,
                                       startAngle: 0,
                                       endAngle: .pi * 2,
                                       clockwise: true).cgPath
        layer.addSublayer(shapeLayer)
        return shapeLayer
    } ()
    
    private lazy var shapeMaskLayer: CAShapeLayer = {
        let shapeMaskLayer = CAShapeLayer()
        shapeMaskLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        shapeMaskLayer.strokeColor = UIColor.blue.cgColor
        shapeMaskLayer.fillColor = UIColor.clear.cgColor
        shapeMaskLayer.lineWidth = 2
        shapeMaskLayer.lineCap = .round
        shapeMaskLayer.strokeEnd = 0
        shapeMaskLayer.strokeStart = 0
        shapeMaskLayer.path = UIBezierPath(arcCenter: CGPoint(x: 10, y: 10),
                                       radius: 9,
                                       startAngle: 0,
                                       endAngle: .pi * 2,
                                       clockwise: true).cgPath
        shapeLayer.mask = shapeMaskLayer
        return shapeMaskLayer
    } ()
    
    private var isAnimationg = false
    
    // MARK: - Implementation Of Animation
    
    func startAnimating() {
        if isAnimationg {
            return
        }
        isAnimationg = true
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.fromValue = 0
        strokeEnd.duration = 0.88
        strokeEnd.fillMode = .forwards

        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.toValue = 1
        strokeStart.fromValue = 0
        strokeStart.duration = 0.88
        strokeStart.beginTime = 0.62

        let strokeGroup = CAAnimationGroup()
        strokeGroup.duration = 1.5
        strokeGroup.repeatCount = HUGE
        strokeGroup.isRemovedOnCompletion = false
        strokeGroup.animations = [strokeEnd, strokeStart]
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = CGFloat.pi * 2
        rotate.duration = 1.5
        rotate.repeatCount = HUGE
        rotate.isRemovedOnCompletion = false
        
        shapeLayer.add(rotate, forKey: nil)
        shapeMaskLayer.add(strokeGroup, forKey: nil)
        isHidden = false
    }
    
    func stopAnimating() {
        if !isAnimationg {
            return
        }
        isAnimationg = false
        
        shapeLayer.removeAllAnimations()
        shapeMaskLayer.removeAllAnimations()
        isHidden = true
    }
    
    // MARK: - Layout
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
    
}
