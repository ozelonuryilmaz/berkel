//
//  SplashUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit
import FirebaseAuth

public var jobiUuid: String = "unknown"

protocol ISplashUIModel {

    var isHaveAnySeason: Bool { get }

    init()

    func decideToScreen(accounting: () -> (Void),
                        jobi: () -> (Void),
                        moduleSelection: () -> (Void))

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
    
    private var jobiAdminKey: String {
        return "gwkyj3WNUNhBpA1RJYFgfH7K8to2"
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
                        moduleSelection: () -> (Void)) {

        if self.userId == self.jobiAdminKey {
            jobiUuid = self.jobiAdminKey
            moduleSelection()
        } else if true == user?.isAdmin && true == user?.isStockAdmin {
            jobiUuid = self.jobiAdminKey
            moduleSelection()
        } else if true == user?.isAdmin {
            jobiUuid = "unknown"
            moduleSelection()
        } else if true == user?.isStockAdmin {
            jobiUuid = self.jobiAdminKey
            jobi()
        } else {
            jobiUuid = self.userId ?? "unknown"
            jobi()
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
        jobiUuid = self.user?.id ?? "unknown"
    }
}
