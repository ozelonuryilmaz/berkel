//
//  SeasonItemService.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import FirebaseFirestore

enum SeasonItemService {

    case save
    case list
}

extension SeasonItemService: CollectionServiceType {

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
        case .list, .save:

            return Firestore
                .firestore()
                .collection("seasons")
        }
    }
}
