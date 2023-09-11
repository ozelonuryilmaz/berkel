//
//  SplashUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit
import FirebaseAuth

protocol ISplashUIModel {

    init()

    func isUserAlreadyLogin(completion: @escaping (Bool) -> Void)
}

struct SplashUIModel: ISplashUIModel {

    // MARK: Definitions

    // MARK: Initialize
    init() {

    }

    // MARK: Computed Props

    func isUserAlreadyLogin(completion: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            completion(user != nil)
        }
    }


}

// MARK: Props
extension SplashUIModel {

}
