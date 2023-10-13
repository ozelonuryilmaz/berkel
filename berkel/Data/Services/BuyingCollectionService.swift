//
//  BuyingCollectionService.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.10.2023.
//

import FirebaseFirestore

enum BuyingCollectionService {

    case save(season: String, buyingId: String)
}

extension BuyingCollectionService: CollectionServiceType {

    var collectionReference: CollectionReference {
        switch self {
        case .save(let season, let buyingId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
                .collection("collections")
        }
    }
}
