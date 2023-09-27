//
//  NewBuyingService.swift
//  berkel
//
//  Created by Onur Yilmaz on 27.09.2023.
//

import FirebaseFirestore

enum NewBuyingService {

    case save(season: String)
}

extension NewBuyingService: CollectionServiceType {
    

    var collectionReference: CollectionReference {
        switch self {
        case .save(let season):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
        }
    }
}
