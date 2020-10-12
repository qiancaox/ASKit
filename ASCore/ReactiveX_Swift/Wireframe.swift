//
//  Wireframe.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/3/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift
#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public protocol Wireframe {
    func open(url: URL)
    func promptFor<Action>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> where Action: CustomStringConvertible
}


final public class DefaultWireframe: Wireframe {
    
    static let shared = DefaultWireframe()

    public func open(url: URL) {
        #if os(iOS)
        UIApplication.shared.openURL(url)
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }

    #if os(iOS)
    private static func rootViewController() -> UIViewController {
        // cheating, I know
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    #endif

    static func presentAlert(_ message: String) {
        #if os(iOS)
        let alertView = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        rootViewController().present(alertView, animated: true, completion: nil)
        #endif
    }

    public func promptFor<Action>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> where Action: CustomStringConvertible {
        #if os(iOS)
        return Observable.create { observer in
            let alertView = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })

            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }

            DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)

            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
        #elseif os(macOS)
        return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
        #endif
    }
    
}
