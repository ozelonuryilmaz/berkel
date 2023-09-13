//
//  LoginUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol ILoginUIModel {

    var email: String { get }
    var password: String { get }

    init(data: LoginPassData)

    mutating func setEmail(_ email: String)
    mutating func setPassword(_ password: String)
}

struct LoginUIModel: ILoginUIModel {

    // MARK: Definitions
    var email: String = ""
    var password: String = ""

    // MARK: Initialize
    init(data: LoginPassData) {

    }

    // MARK: Computed Props
}

// MARK: Props
extension LoginUIModel {

}

// MARK: Setter
extension LoginUIModel {

    mutating func setEmail(_ email: String) {
        self.email = email
    }

    mutating func setPassword(_ password: String) {
        self.password = password
    }
}
