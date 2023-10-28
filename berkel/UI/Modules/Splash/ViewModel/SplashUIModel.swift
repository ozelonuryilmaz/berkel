//
//  SplashUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit
import FirebaseAuth

protocol ISplashUIModel {
    
    var isHaveAnySeason: Bool { get }

    init()

    func isUserAlreadyLogin(completion: @escaping (Bool) -> Void)
}

struct SplashUIModel: ISplashUIModel {

    // MARK: Definitions
    
    var isHaveAnySeason: Bool {
        return UserDefaultsManager.shared.getStringValue(key: .season) != nil
    }

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
