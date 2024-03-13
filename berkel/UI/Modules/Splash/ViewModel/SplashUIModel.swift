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

    func decideToScreen(accounting: () -> (Void),
                        jobi: () -> (Void),
                        allOfThem: () -> (Void),
                        denied: () -> (Void))

    func isUserAlreadyLogin(completion: @escaping (Bool) -> Void)
    mutating func setUsers(users: [UserModel])
}

struct SplashUIModel: ISplashUIModel {

    // MARK: Definitions
    private var user: UserModel? = nil

    var userId: String? {
        return UserManager.shared.userId
    }

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

    func decideToScreen(accounting: () -> (Void),
                        jobi: () -> (Void),
                        allOfThem: () -> (Void),
                        denied: () -> (Void)) {

    if self.userId == "gwkyj3WNUNhBpA1RJYFgfH7K8to2" {
        allOfThem()
    } else if true == user?.isAdmin && true == user?.isStockAdmin {
        allOfThem()
    } else if true == user?.isAdmin {
        accounting()
    } else if true == user?.isStockAdmin {
        jobi()
    } else {
        denied()
    }
}
}

// MARK: Props
extension SplashUIModel {


}

// MARK: Setter
extension SplashUIModel {

    mutating func setUsers(users: [UserModel]) {
        self.user = users.filter({ $0.id == userId }).first
    }
}
