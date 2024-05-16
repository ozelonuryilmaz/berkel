//
//  JobiJobiProductItemService.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.05.2024.
//

import FirebaseFirestore

enum JobiProductItemService {

    case save
    case list
}

extension JobiProductItemService: CollectionServiceType {

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
        case .list, .save:

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("products")
        }
    }
}
