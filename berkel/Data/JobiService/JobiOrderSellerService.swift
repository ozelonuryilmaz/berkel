//
//  JobiOrderSellerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.05.2024.
//

import FirebaseFirestore

enum JobiOtherSellerService {

    case list
    case save
    case update(id: String)
}

extension JobiOtherSellerService: CollectionServiceType {
    
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
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("otherSeller")
            
        case .list:

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("otherSeller")
            
        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}

extension JobiOtherSellerService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .update(let id):
            
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("otherSeller")
                .document(id)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
