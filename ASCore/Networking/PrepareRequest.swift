//  PrepareRequest.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Moya

/// A closure to prepare configurate request.
public typealias PrepareRequestClosure = (_ request: URLRequest, _ target: TargetType) -> URLRequest

/// Used to make a common HTTP header fields.
public final class PrepareRequest: PluginType {
    
    private let closure: PrepareRequestClosure
    
    public init(_ closure: @escaping PrepareRequestClosure) {
        self.closure = closure
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        closure(request, target)
    }
    
}
