//  Response+HandyJSON.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import HandyJSON
import Moya

public extension Response {
    
    func mapModel<H>(_ type: H.Type) throws -> H where H: HandyJSON {
        let jsonString = String.init(data: data, encoding: .utf8)
        guard let object = JSONDeserializer<H>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
}
