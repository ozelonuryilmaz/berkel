//
//  OtherSellerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import FirebaseFirestore

enum OtherSellerService {

    case list
    case save
    case update(id: String)
}

extension OtherSellerService: CollectionServiceType {
    
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
                .collection("otherSeller")
            
        case .list:

            return Firestore
                .firestore()
                .collection("otherSeller")
            
        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}

extension OtherSellerService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .update(let id):
            
            return Firestore
                .firestore()
                .collection("otherSeller")
                .document(id)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
