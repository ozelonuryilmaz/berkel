//
//  UserDefaultsManager.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard

    
}

// MARK: Setter
extension UserDefaultsManager {
    
    func set(value: String, key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
}

// MARK: Getter
extension UserDefaultsManager {
    
    func getStringValue(key: UserDefaultsKey) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
}

// MARK: Remove
extension UserDefaultsManager {
    
    func remove(key: UserDefaultsKey) {
        self.userDefaults.removeObject(forKey: key.rawValue)
    }
}

// MARK: Keys
enum UserDefaultsKey: String {
    case season = "SEASON"
}
