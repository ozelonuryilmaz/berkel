//
//  OtherSellerCategoryItemService.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import FirebaseFirestore

enum OtherSellerCategoryItemService {

    case save
    case list
}

extension OtherSellerCategoryItemService: CollectionServiceType {

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
                .collection("otherSellerCategory")
        }
    }
}
