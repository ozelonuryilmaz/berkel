//
//  SplashUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit
import FirebaseAuth

// Canlıya çıkıldığında admin ve bahadir Key güncelle
// GoogleService-info güncelle

public var jobiUuid: String = "unknown"
public var jobiCollection: String = "unknown"
public var otherModule: OtherModuleType = .accouting

public var jobiAdminKey: String {
    return "gwkyj3WNUNhBpA1RJYFgfH7K8to2"
}

public var jobiBahadirKey: String {
    return "ObKWhlJloOXGS0tHmx9CEyesgMc2"
}

/* // MARK: Test key
public var jobiAdminKey: String {
    return "gwkyj3WNUNhBpA1RJYFgfH7K8to2"
}

public var jobiBahadirKey: String {
    return "ObKWhlJloOXGS0tHmx9CEyesgMc2"
}
*/

/* // MARK: Prod key
public var jobiAdminKey: String {
    return "jTk3PbUOcMazaqbfbcP6O2xyrgh1"
}

public var jobiBahadirKey: String {
    return "b2tlFw1hekM5uFBlHZ67V2YrKSX2"
}
*/

// Sonsuz döngü engellendi
fileprivate var isOneTimeRestart = true

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
            isOneTimeRestart = true
            jobiUuid = jobiAdminKey
            jobiCollection = self.jobiAdmin
            moduleSelection()
        } else if self.userId == jobiBahadirKey {
            isOneTimeRestart = true
            jobiUuid = jobiBahadirKey
            jobiCollection = self.jobiAdmin
            jobi()
        } else if true == user?.isAdmin && true == user?.isStockAdmin {
            isOneTimeRestart = true
            jobiUuid = jobiAdminKey
            jobiCollection = self.jobiAdmin
            moduleSelection()
        } else if true == user?.isAdmin {
            isOneTimeRestart = true
            jobiUuid = self.userId ?? "unknown"
            jobiCollection = self.jobiGuest
            accounting()
        } else if true == user?.isStockAdmin {
            isOneTimeRestart = true
            jobiUuid = jobiAdminKey
            jobiCollection = self.jobiAdmin
            jobi()
        } else if self.user == nil && isOneTimeRestart {
            isOneTimeRestart = false
            restart()
        } else {
            isOneTimeRestart = true
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

public enum OtherModuleType {
    case accouting
    case jobi
}
