//
//  UserService.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.01.2024.
//

import FirebaseFirestore

enum UserService {

    case save(userId: String)
    case list
    case tempSave(userId: String)
    case tempList
}

extension UserService: CollectionServiceType {

    var order: String {
        switch self {
        case .list:
            return "date"
        default:
            return ""
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .list:

            return Firestore
                .firestore()
                .collection("users")
            
        case .tempList:

            return Firestore
                .firestore()
                .collection("tempUsers")
            
        default:
            return Firestore
                .firestore()
                .collection("")
        }
    }
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

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
