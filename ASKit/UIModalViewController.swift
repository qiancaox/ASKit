//  UIModalViewController.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit
import SnapKit

public protocol UIModalCustomizeTransitions where Self: UIViewController {

    /// Customize present animation for content display views.
    /// - Parameters:
    ///   - tagertViewController: Target view controller.
    ///   - duration: The total time should animation cost.
    func presentViewController(_ tagertViewController: UIViewController, withDuration duration: TimeInterval)
    
    
    /// Customize dismiss animation for content display views.
    /// - Parameters:
    ///   - sourceViewController: Source view controller.
    ///   - duration: The total time should animation cost.
    func dismissViewController(_ sourceViewController: UIViewController, withDuration duration: TimeInterval)
    
}

// MARK: - Customize Modal Transitions Animation Implementation

/// Implementations for modal transition animation.
fileprivate class UIModalCustomizeTransitionImpl: NSObject {
    
    enum ModalOperation {
        case present, dismiss
    }
    
    /// Handle controller to add touch dismiss action.
    weak var controller: UIModalCustomizeTransitions!
    
    /// Operation of modal type.
    var operation: ModalOperation = .present
    
    /// Duration of transition animation.
    var animationDuration: TimeInterval = 0.268
    
    init(_ controller: UIModalCustomizeTransitions) {
        self.controller = controller
        super.init()
    }
    
}

extension UIModalCustomizeTransitionImpl: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if case .present = operation {
            presentAnimation(using: transitionContext)
        } else {
            dismissAnimation(using: transitionContext)
        }
    }
    
    // MARK: - Animation
    
    /// Present animation.
    private func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        // Add background view.
        let backgroundView = UIView()
        backgroundView.tag = 10
        backgroundView.alpha = 0
        backgroundView.backgroundColor = UIColor(white: 0.121, alpha: 0.421)
        containerView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Add to view.
        let toView = transitionContext.view(forKey: .to)!
        containerView.addSubview(toView)
        
        // Add dismiss button.
        let dismissButton = UIButton()
        dismissButton.addTarget(self, action: #selector(shouldDismissByTouched(_:)), for: .touchUpInside)
        toView.insertSubview(dismissButton, at: 0)
        dismissButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Make animation
        UIView.animate(withDuration: animationDuration, animations: {
            backgroundView.alpha = 1
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        // Call customize function.
        controller.presentViewController(transitionContext.viewController(forKey: .from)!, withDuration: animationDuration)
    }
    
    /// Dismiss animation.
    private func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        // Get backgroun view.
        let backgroundView = containerView.viewWithTag(10)!
        
        // Get from view.
        let fromView = transitionContext.view(forKey: .from)!
        
        // Make animation and remove from view when finished.
        UIView.animate(withDuration: animationDuration, animations: {
            backgroundView.alpha = 0
        }) { _ in
            backgroundView.removeFromSuperview()
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        // Call customize function.
        controller.dismissViewController(transitionContext.viewController(forKey: .from)!, withDuration: animationDuration)
    }
    
    // MARK: - Handlers
    
    @objc private func shouldDismissByTouched(_ sender: Any) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIModalViewController

open class UIModalViewController: UIViewController, UIModalCustomizeTransitions {
    
    /// Transition animation implementation.
    private var transitionImpl: UIModalCustomizeTransitionImpl!
    
    // MARK: - Initialize
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
        transitionImpl = UIModalCustomizeTransitionImpl(self)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
        transitionImpl = UIModalCustomizeTransitionImpl(self)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    // MARK: - Function for customer to customize other animations.
    
    open func presentViewController(_ tagertViewController: UIViewController, withDuration duration: TimeInterval) {
    }
    
    open func dismissViewController(_ sourceViewController: UIViewController, withDuration duration: TimeInterval) {
    }
    
}

extension UIModalViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionImpl.operation = .present
        return transitionImpl
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionImpl.operation = .dismiss
        return transitionImpl
    }
    
}
