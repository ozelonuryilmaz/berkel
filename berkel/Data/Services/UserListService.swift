//
//  UserListService.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.01.2024.
//

import FirebaseFirestore

enum UserListService {

    case list
    case tempList
}

extension UserListService: CollectionServiceType {

    var order: String {
        switch self {
        case .list, .tempList:
            return "date"
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .tempList:

            return Firestore
                .firestore()
                .collection("tempUsers")

        case .list:

            return Firestore
                .firestore()
                .collection("users")
        }
    }
}
