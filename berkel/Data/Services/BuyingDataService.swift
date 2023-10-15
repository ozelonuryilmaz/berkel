//
//  BuyingDataService.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.10.2023.
//

import FirebaseFirestore

enum BuyingDataService {

    case collection(season: String, buyingId: String)
    case payment(season: String, buyingId: String)
}

extension BuyingDataService: CollectionServiceType {
    
    var order: String {
        switch self {
        case .collection(_, _), .payment(_, _):
            return "date"
        default:
            return ""
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .collection(let season, let buyingId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
                .collection("collections")
            
        case .payment(let season, let buyingId):

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
