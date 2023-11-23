//
//  CustomerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import FirebaseFirestore

enum CustomerService {

    case list
    case save
}

extension CustomerService: CollectionServiceType {
    
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
                .collection("customer")
            
        case .list:

            return Firestore
                .firestore()
                .collection("customer")
        }
    }
}
