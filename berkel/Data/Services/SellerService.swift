//
//  SellerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.11.2023.
//

import FirebaseFirestore

enum SellerService {

    case save(season: String)
    case list(season: String)
    case collection(season: String, sellerId: String)
    case payment(season: String, sellerId: String)
    case seller(season: String, sellerId: String, collectionId: String)
}

extension SellerService: CollectionServiceType {
    
    var order: String {
        switch self {
        case .save(_), .list(_), .collection(_, _), .payment(_, _):
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
                .collection("seller")
            
        case .collection(let season, let sellerId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("seller")
                .document(sellerId)
                .collection("collections")
            
        case .payment(let season, let sellerId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("seller")
                .document(sellerId)
                .collection("payments")
            
        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")

        }
    }
}


extension SellerService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .seller(let season, let sellerId, let collectionId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("seller")
                .document(sellerId)
                .collection("collections")
                .document(collectionId)
            
        case .collection(let season, let sellerId):
            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("seller")
                .document(sellerId)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
