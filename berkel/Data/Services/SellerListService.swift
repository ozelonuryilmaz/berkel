//
//  SellerListService.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//

import FirebaseFirestore

enum SellerListService {

    case save
    case update(id: String)
}

extension SellerListService: CollectionServiceType {
    
    var collectionReference: CollectionReference {
        switch self {
        case .save:

            return Firestore
                .firestore()
                .collection("seller")

        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}

extension SellerListService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .update(let id):
            
            return Firestore
                .firestore()
                .collection("seller")
                .document(id)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
