//
//  NewBuyingService.swift
//  berkel
//
//  Created by Onur Yilmaz on 27.09.2023.
//

import FirebaseFirestore

enum NewBuyingService {

    case list(season: String)
    case save(season: String)
    case saveFirstPayment(season: String, buyingId: String)
}

extension NewBuyingService: CollectionServiceType {

    var order: String {
        switch self {
        case .list(_):
            return "date"
        default:
            return ""
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .save(let season), .list(let season):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")

        case .saveFirstPayment(let season, let buyingId):
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
