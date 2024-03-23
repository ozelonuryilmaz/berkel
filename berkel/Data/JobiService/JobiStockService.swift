//
//  StockService.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import FirebaseFirestore

enum JobiStockService {

    case save
    case list
}

extension JobiStockService: CollectionServiceType {

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
                .collection("jobi")
                .document(jobiUuid)
                .collection("stock")
        }
    }
}
