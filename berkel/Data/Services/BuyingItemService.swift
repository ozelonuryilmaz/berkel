//
//  BuyingItemService.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import FirebaseFirestore

enum BuyingItemService {

    case list
}

extension BuyingItemService: CollectionServiceType {

    var collectionReference: CollectionReference {
        switch self {
        case .list:

            return Firestore
                .firestore()
                .collection("seller")
        }
    }
}
