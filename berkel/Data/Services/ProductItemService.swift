//
//  ProductItemService.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import FirebaseFirestore

enum ProductItemService {

    case save
    case list
}

extension ProductItemService: CollectionServiceType {

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
                .collection("products")
        }
    }
}
