//
//  JBCustomerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//

import FirebaseFirestore

enum JBCustomerService {

    case update(id: String)
    case customer
    case prices(customerId: String, season: String, stockId: String, subStockId: String)
}

extension JBCustomerService: CollectionServiceType {
    
    var order: String {
        switch self {
        case .customer, .prices(_,_,_,_):
            return "date"
        default:
            return ""
        }
    }
    
    var collectionReference: CollectionReference {
        switch self {
        case .customer:
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiCustomer")
            
        case .prices(let customerId, let season, let stockId, let subStockId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiCustomer")
                .document(customerId)
                .collection("data")
                .document(season)
                .collection("stock")
                .document(stockId)
                .collection("subStocks")
                .document(subStockId)
                .collection("prices")

        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}

extension JBCustomerService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .update(let id):
            
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiCustomer")
                .document(id)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
