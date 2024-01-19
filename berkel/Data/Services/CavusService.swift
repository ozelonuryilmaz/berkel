//
//  CavusService.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import FirebaseFirestore

enum CavusService {

    case list
    case save
    case update(id: String)
}

extension CavusService: CollectionServiceType {
    
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
                .collection("cavus")
            
        case .list:

            return Firestore
                .firestore()
                .collection("cavus")
            
        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}

extension CavusService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .update(let id):
            
            return Firestore
                .firestore()
                .collection("cavus")
                .document(id)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
