//
//  NewBuyingService.swift
//  berkel
//
//  Created by Onur Yilmaz on 27.09.2023.
//

import FirebaseFirestore

enum NewBuyingService {

    case list(season: String)
    case save(season: String)
}

extension NewBuyingService: CollectionServiceType {
    
    var order: String {
        switch self {
        case .list(_):
            return "date"
        default:
            return ""
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .save(let season), .list(let season):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("buying")
        }
    }
}
