//  UIGestureRecognizer+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

/**
 * Nomore needed, becuz of Rx.
// MARK: - Responds with block.
/// The closure of recognizer to responds.
typealias UIGestureRecognizerBlockResponder = (UIGestureRecognizer) -> Void

fileprivate class _UIGestureRecognizerBlockTarget {
    
    private let responder: UIGestureRecognizerBlockResponder
    
    init(_ responder: @escaping UIGestureRecognizerBlockResponder) {
        self.responder = responder
    }
    
    @objc func invoke(_ sender: UIGestureRecognizer) {
        responder(sender)
    }
}
*/

public extension UIGestureRecognizer {
    
    /// The identifier property associate key.
    private static var identifierAssociateKey = 0
    
    /// The identifier of recognizer.
    var identifier: String? {
        get { objc_getAssociatedObject(self, &UIGestureRecognizer.identifierAssociateKey) as? String }
        set { objc_setAssociatedObject(self, &UIGestureRecognizer.identifierAssociateKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /**
     * Nomore needed, becuz of Rx.
    // MARK: - Responds with block.
    
    /// The block targets array associate key.
    private static var blockTargetsAssociateKey = 1
    
    /// The array of block targets.
    private var blockTargets: [_UIGestureRecognizerBlockTarget] {
        get {
            guard let targets = objc_getAssociatedObject(self, &UIGestureRecognizer.blockTargetsAssociateKey) as? [_UIGestureRecognizerBlockTarget] else {
                return []
            }
            return targets
        }
        set { objc_setAssociatedObject(self, &UIGestureRecognizer.blockTargetsAssociateKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    convenience init(respondTo responder: @escaping UIGestureRecognizerBlockResponder) {
        self.init()
        let target = _UIGestureRecognizerBlockTarget(responder)
        addTarget(target, action: #selector(target.invoke(_:)))
        blockTargets.append(target)
    }
    
    func removeAllResponders() {
        for target in blockTargets {
            removeTarget(target, action: #selector(target.invoke(_:)))
        }
        blockTargets.removeAll()
    }
 */
}

public extension UIGestureRecognizer {
    
    private static var kStorageBlocking = "Gesture_Blocking"
    
    /// Initialize a gesture recognizer with block.
    convenience init(_ block: @escaping (UIGestureRecognizer) -> Void) {
        let blockInvoke = BlockInvokeObject(block)
        self.init(target: blockInvoke, action: #selector(BlockInvokeObject.respondsToGesture(_:)))
        objc_setAssociatedObject(self, &UIGestureRecognizer.kStorageBlocking, blockInvoke, .OBJC_ASSOCIATION_RETAIN)
    }
    
}


// MARK: - Private BlockInvokeObject

fileprivate class BlockInvokeObject {
    
    private let block: (UIGestureRecognizer) -> Void
    
    init(_ block: @escaping (UIGestureRecognizer) -> Void) {
        self.block = block
    }
    
    @objc
    func respondsToGesture(_ sender: UIGestureRecognizer) {
        block(sender)
    }
    
}
