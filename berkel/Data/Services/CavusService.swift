//
//  CavusService.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import FirebaseFirestore

enum CavusService {

    case save
}

extension CavusService: CollectionServiceType {
    
    var collectionReference: CollectionReference {
        switch self {
        case .save:

            return Firestore
                .firestore()
                .collection("cavus")
        }
    }
}
