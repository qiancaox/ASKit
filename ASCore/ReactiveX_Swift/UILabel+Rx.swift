//  UILabel+Rx.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import RxCocoa
import RxSwift

public extension Reactive where Base: UILabel {
    
    /// Bindable sink for `textColor` property.
    var textColor: Binder<UIColor?> {
        return Binder(self.base) { label, textColor in
            label.textColor = textColor
        }
    }
    
}
