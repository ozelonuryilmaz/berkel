//
//  SplashUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit
import FirebaseAuth

public var jobiUuid: String = "unknown"
public var jobiCollection: String = "unknown"

public var jobiAdminKey: String {
    return "gwkyj3WNUNhBpA1RJYFgfH7K8to2"
}

public var jobiBahadirKey: String {
    return "ObKWhlJloOXGS0tHmx9CEyesgMc2"
}

protocol ISplashUIModel {

    var isHaveAnySeason: Bool { get }

    init()

    func decideToScreen(accounting: () -> (Void),
                        jobi: () -> (Void),
                        moduleSelection: () -> (Void),
                        restart: () -> (Void))

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
    
    private var jobiAdmin: String {
        return "jobi"
    }
    
    private var jobiGuest: String {
        return "jobiGuest"
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
                        moduleSelection: () -> (Void),
                        restart: () -> (Void)) {

        if self.userId == jobiAdminKey {
            jobiUuid = jobiAdminKey
            jobiCollection = self.jobiAdmin
            moduleSelection()
        } else if self.userId == jobiBahadirKey {
            jobiUuid = jobiBahadirKey
            jobiCollection = self.jobiAdmin
            jobi()
        } else if true == user?.isAdmin && true == user?.isStockAdmin {
            jobiUuid = jobiAdminKey
            jobiCollection = self.jobiAdmin
            moduleSelection()
        } else if true == user?.isAdmin {
            jobiUuid = self.userId ?? "unknown"
            jobiCollection = self.jobiGuest
            accounting()
        } else if true == user?.isStockAdmin {
            jobiUuid = jobiAdminKey
            jobiCollection = self.jobiAdmin
            jobi()
        } else if self.user == nil {
            restart()
        } else {
            jobiUuid = self.userId ?? "unknown"
            jobiCollection = self.jobiGuest
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
