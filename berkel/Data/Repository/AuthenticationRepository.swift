//
//  AuthenticationRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import Foundation
import FirebaseAuth

protocol IAuthenticationRepository: AnyObject {
    
    func saveUser(id: String, data: SaveUserInput) -> FirestoreResponseType<SaveUserInput>
    func login(email: String,
               password: String,
               completionError: @escaping (String) -> Void,
               completionSuccess: @escaping () -> Void)
    func register(email: String,
                  password: String,
                  completionError: @escaping (String) -> Void,
                  completionSuccess: @escaping () -> Void)
    func sendResetLink(email: String,
                       completionError: @escaping (String) -> Void,
                       completionSuccess: @escaping () -> Void)
    func logOut(completionError: @escaping (String) -> Void,
                completionSuccess: @escaping () -> Void)
}

final class AuthenticationRepository: BaseRepository, IAuthenticationRepository {
    
    private let auth = Auth.auth()
    
    func saveUser(id: String, data: SaveUserInput) -> FirestoreResponseType<SaveUserInput> {
        return setData(AuthService.saveUser(id: id), data: data)
    }

    func login(email: String,
               password: String,
               completionError: @escaping (String) -> Void,
               completionSuccess: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completionError(error.localizedDescription)
            } else {
                completionSuccess()
            }
        }
    }

    func register(email: String,
                  password: String,
                  completionError: @escaping (String) -> Void,
                  completionSuccess: @escaping () -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completionError(error.localizedDescription)
            } else {
                completionSuccess()
            }
        }
    }

    func sendResetLink(email: String,
                       completionError: @escaping (String) -> Void,
                       completionSuccess: @escaping () -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completionError(error.localizedDescription)
            } else {
                completionSuccess()
            }
        }
    }

    func logOut(completionError: @escaping (String) -> Void,
                completionSuccess: @escaping () -> Void) {
        do {
            try auth.signOut()
            completionSuccess()
        } catch let error as NSError {
            completionError(error.localizedDescription)
        }
    }

}
