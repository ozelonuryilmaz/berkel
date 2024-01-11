//
//  UserService.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.01.2024.
//

import FirebaseFirestore

enum UserService {

    case save(userId: String)
    case tempSave(userId: String)
    case delete(userId: String)
}

extension UserService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .save(let userId):

            return Firestore
                .firestore()
                .collection("users")
                .document(userId)

        case .tempSave(let userId):
            return Firestore
                .firestore()
                .collection("tempUsers")
                .document(userId)

        case .delete(let userId):
            return Firestore
                .firestore()
                .collection("tempUsers")
                .document(userId)
        }
    }


}
