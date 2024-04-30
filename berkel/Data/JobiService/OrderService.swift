//
//  OrderService.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.04.2024.
//

import FirebaseFirestore

enum OrderService {

    case order(season: String)
    case customerCollections(season: String, customerId: String, orderId: String)
    case customerPayments(season: String, customerId: String, orderId: String)
    case none
}

extension OrderService: CollectionServiceType {

    var order: String {
        switch self {
        case .order(_), .customerCollections(_, _, _), .customerPayments(_, _, _):
            return "date"

        default:
            return ""
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .order(let season):
            return Firestore
                .firestore()
                .collection("jobiOrder")
                .document(season)
                .collection("order")

        case .customerCollections(let season, let customerId, let orderId):
            return Firestore
                .firestore()
                .collection("jobiOrderDetail")
                .document(season)
                .collection(customerId)
                .document(orderId)
                .collection("collections")

        case .customerPayments(let season, let customerId, let orderId):
            return Firestore
                .firestore()
                .collection("jobiOrderDetail")
                .document(season)
                .collection(customerId)
                .document(orderId)
                .collection("payments")

        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}

extension OrderService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
