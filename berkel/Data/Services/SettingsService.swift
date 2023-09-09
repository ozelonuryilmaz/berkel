//
//  BuyingService.swift
//  berkel
//
//  Created by Onur Yilmaz on 5.09.2023.
//

import FirebaseFirestore

enum SettingsService {

    case list
}

extension SettingsService: CollectionServiceType {

    var collectionReference: CollectionReference {
        switch self {
        case .list:

            return Firestore
                .firestore()
                .collection("seasons")
                .document("2022-2023")
                .collection("buying")
        }
    }
}
