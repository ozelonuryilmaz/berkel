//
//  BuyingCollectionService.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.10.2023.
//

import FirebaseFirestore

enum BuyingCollectionService {

    case saveCollection(season: String, buyingId: String)
    case savePayment(season: String, buyingId: String)
}

extension BuyingCollectionService: CollectionServiceType {

    var collectionReference: CollectionReference {
        switch self {
        case .saveCollection(let season, let buyingId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
                .collection("collections")
            
        case .savePayment(let season, let buyingId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
                .collection("payments")
        }
    }
}
