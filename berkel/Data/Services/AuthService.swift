//
//  AuthService.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.09.2023.
//

import Foundation
import FirebaseFirestore

enum AuthService {

    case saveUser(id: String)
}

extension AuthService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .saveUser(let id):

            return Firestore
                .firestore()
                .collection("users")
                .document(id)
        }
    }
}
