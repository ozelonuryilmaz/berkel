//
//  JBCustomerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//

import FirebaseFirestore

enum JBCustomerService {

    case list
    case save
    case update(id: String)
}

extension JBCustomerService: CollectionServiceType {
    
    var order: String {
        switch self {
        case .list:
            return "date"
        default:
            return ""
        }
    }
    
    var collectionReference: CollectionReference {
        switch self {
        case .save:

            return Firestore
                .firestore()
                .collection("jobiCustomer")
            
        case .list:

            return Firestore
                .firestore()
                .collection("jobiCustomer")
            
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
                .collection("jobiCustomer")
                .document(id)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
