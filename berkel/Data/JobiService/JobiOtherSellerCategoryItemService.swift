//
//  JobiJobiOtherSellerCategoryItemService.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.05.2024.
//

import FirebaseFirestore

enum JobiOtherSellerCategoryItemService {

    case save
    case list
}

extension JobiOtherSellerCategoryItemService: CollectionServiceType {

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
                .collection("otherSellerCategory")
        }
    }
}
