//
//  AuthenticationRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import Foundation
import FirebaseAuth

protocol IAuthenticationRepository: AnyObject {

    func login(email: String,
               password: String,
               completionError: @escaping (String) -> Void,
               completionSuccess: @escaping () -> Void)
    func register(name: String,
                  email: String,
                  password: String,
                  completionError: @escaping (String) -> Void,
                  completionSuccess: @escaping () -> Void)
    func sendResetLink(email: String,
                       completionError: @escaping (String) -> Void,
                       completionSuccess: @escaping () -> Void)
    func logOut(completionError: @escaping (String) -> Void,
                completionSuccess: @escaping () -> Void)
}

final class AuthenticationRepository: IAuthenticationRepository {

    private let auth = Auth.auth()

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

    func register(name: String,
                  email: String,
                  password: String,
                  completionError: @escaping (String) -> Void,
                  completionSuccess: @escaping () -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completionError(error.localizedDescription)
            } else {

                // displayName'e kullanıcı ismi aktarıldı. Auth() içerisinden erişilebilecek
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    completionSuccess()
                }

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
