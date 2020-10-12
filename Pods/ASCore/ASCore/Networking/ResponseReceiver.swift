//  ResponseReceiver.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Moya
import Result

/// A closure of received response.
public typealias ResponseReceiveClosure = (_ result: Result<Moya.Response, MoyaError>) -> Void

/// Can use this plugin to make token invalid listener.
public final class ResponseReceiver: PluginType {
    
    private let closure: ResponseReceiveClosure
    
    public init(_ closure: @escaping ResponseReceiveClosure) {
        self.closure = closure
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        closure(result)
    }
    
}
