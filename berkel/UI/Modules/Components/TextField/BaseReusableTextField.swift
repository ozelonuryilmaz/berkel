//
//  BaseReusableTextField.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import UIKit

open class BaseReusableTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSelf()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSelf()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initializeSelf()
    }

    internal func initializeSelf() {
        preconditionFailure("initializeSelf - This method must be overridden")
    }
}

