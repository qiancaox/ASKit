//  Response+Observable<HandyJSON>.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import HandyJSON
import Moya
import RxSwift

public extension ObservableType where E == Response {
    
    func mapModel<H>(_ type: H.Type) -> Observable<H> where H: HandyJSON {
        return flatMap { response -> Observable<H> in
            return Observable.just(try response.mapModel(H.self))
        }
    }
    
}
