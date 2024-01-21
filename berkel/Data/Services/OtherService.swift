//
//  OtherService.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import FirebaseFirestore

enum OtherService {

    case save(season: String)
    case list(season: String)
    case collection(season: String, otherId: String)
    case payment(season: String, otherId: String)
    case deletePayment(season: String, otherId: String, paymentId: String)
    case other(season: String, otherId: String, collectionId: String)
}

extension OtherService: CollectionServiceType {
    
    var order: String {
        switch self {
        case .save(_), .list(_), .collection(_, _), .payment(_, _), .deletePayment(_, _, _):
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
                .collection("other")
            
        case .collection(let season, let otherId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("other")
                .document(otherId)
                .collection("collections")
            
        case .payment(let season, let otherId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("other")
                .document(otherId)
                .collection("payments")
            
        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")

        }
    }
}


extension OtherService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .other(let season, let otherId, let collectionId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("other")
                .document(otherId)
                .collection("collections")
                .document(collectionId)
            
        case .collection(let season, let otherId):
            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("other")
                .document(otherId)
            
        case .deletePayment(let season, let otherId, let paymentId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("other")
                .document(otherId)
                .collection("payments")
                .document(paymentId)
            
        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
