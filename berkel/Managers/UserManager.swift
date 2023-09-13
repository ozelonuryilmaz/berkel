//
//  UserManager.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.09.2023.
//

import Foundation
import FirebaseAuth

final class UserManager {
    
    static let shared = UserManager()

    private let auth = Auth.auth()
    
    var userId: String? {
        return auth.currentUser?.uid
    }
    
    var displayName: String? {
        return auth.currentUser?.displayName
    }
}
