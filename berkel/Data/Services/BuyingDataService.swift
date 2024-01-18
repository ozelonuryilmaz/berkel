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
    case deletePayment(season: String, buyingId: String, paymentId: String)
    case wavehouse(season: String, buyingId: String, collectionId: String)
}

extension BuyingDataService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .wavehouse(let season, let buyingId, let collectionId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
                .collection("collections")
                .document(collectionId)

        case .collection(let season, let buyingId):
            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
            
        case .deletePayment(let season,let buyingId,let paymentId):
            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
                .collection("payments")
                .document(paymentId)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}

extension BuyingDataService: CollectionServiceType {

    var order: String {
        switch self {
        case .collection(_, _),
             .payment(_, _),
             .deletePayment(_, _, _),
             .wavehouse(_, _, _):

            return "date"
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

        case .wavehouse(let season, let buyingId, let collectionId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
                .document(buyingId)
                .collection("collections")
                .document(collectionId)
                .collection("wavehouses")

        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}
