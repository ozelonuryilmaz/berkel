//
//  OrderService.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.04.2024.
//

import FirebaseFirestore

enum OrderService {

    case order(season: String)
    case orderDetail(season: String, orderId: String)
    case customerCollections(season: String, customerId: String, orderId: String)
    case customerPayments(season: String, customerId: String, orderId: String)
    case customerCollection(season: String, customerId: String, orderId: String, collectionId: String)
    case customerPayment(season: String, customerId: String, orderId: String, paymentId: String)
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
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiOrder")
                .document(season)
                .collection("order")

        case .customerCollections(let season, let customerId, let orderId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiOrderDetail")
                .document(season)
                .collection(customerId)
                .document(orderId)
                .collection("collections")

        case .customerPayments(let season, let customerId, let orderId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
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
            
        case .orderDetail(let season, let orderId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiOrder")
                .document(season)
                .collection("order")
                .document(orderId)
            
        case .customerCollection(let season, let customerId, let orderId, let collectionId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiOrderDetail")
                .document(season)
                .collection(customerId)
                .document(orderId)
                .collection("collections")
                .document(collectionId)

        case .customerPayment(let season, let customerId, let orderId, let paymentId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiOrderDetail")
                .document(season)
                .collection(customerId)
                .document(orderId)
                .collection("payments")
                .document(paymentId)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
