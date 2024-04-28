//
//  OrderService.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.04.2024.
//

import FirebaseFirestore

enum OrderService {

    case order(season: String)
    case customer(season: String, customerId: String, orderId: String)
    case none
}

extension OrderService: CollectionServiceType {
    
    var order: String {
        switch self {
        case .order(_), .customer(_,_,_):
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
            
        case .customer(let season, let customerId, let orderId):
            return Firestore
                .firestore()
                .collection("jobiOrder")
                .document(season)
                .collection("order")
                .document(customerId)
                .collection(orderId)
            
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
