//  Cell+Rx.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import RxCocoa
import RxSwift

/// Observale for invoked `prepareForReuse`.

public extension Reactive where Base: UICollectionViewCell {
    
    var reused: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(base.prepareForReuse))
            .map { _ in () }
    }
    
}

public extension Reactive where Base: UITableViewCell {
    
    var reused: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(base.prepareForReuse))
            .map { _ in () }
    }
    
}
