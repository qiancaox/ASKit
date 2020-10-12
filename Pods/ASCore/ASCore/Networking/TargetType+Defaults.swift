//  TargetType+Defaults.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Moya

public extension TargetType {
    
    // Defaults to no mock data.
    var sampleData: Data { Data() }
    
    // Defaults to no common header fields.
    var headers: [String: String]? { return nil }
    
}

