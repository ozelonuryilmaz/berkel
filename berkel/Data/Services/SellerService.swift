//
//  SellerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//

import FirebaseFirestore

enum SellerService {

    case save
}

extension SellerService: DocumentServiceType {
    
    var documentReference: DocumentReference {
        switch self {
        case .save:

            return Firestore
                .firestore()
                .collection("seller")
                .document() // uniqe id oluşturulacak
        }
    }
}
