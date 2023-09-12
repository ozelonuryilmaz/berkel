//
//  RegisterUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IRegisterUIModel {

    var name: String { get }
    var email: String { get }
    var password: String { get }
    var rePassword: String { get }

    init(data: RegisterPassData)

    mutating func setName(_ name: String)
    mutating func setEmail(_ email: String)
    mutating func setPassword(_ password: String)
    mutating func setRePassword(_ rePassword: String)
}

struct RegisterUIModel: IRegisterUIModel {

    // MARK: Definitions
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var rePassword: String = ""

    // MARK: Initialize
    init(data: RegisterPassData) {

    }

    // MARK: Computed Props
}

// MARK: Setter
extension RegisterUIModel {

    mutating func setName(_ name: String) {
        self.name = name
    }

    mutating func setEmail(_ email: String) {
        self.email = email
    }

    mutating func setPassword(_ password: String) {
        self.password = password
    }

    mutating func setRePassword(_ rePassword: String) {
        self.rePassword = rePassword
    }
}
