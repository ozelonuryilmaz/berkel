//
//  SellerImageService.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

enum SellerImageService {

    case buyingImage(sellerId: String, season: String, imagePathType: ImagePathType)
    case sellerImage(customerId: String, season: String, imagePathType: ImagePathType)
    case workerImage(cavusId: String, season: String, imagePathType: ImagePathType)
    case otherImage(otherSellerId: String, season: String, imagePathType: ImagePathType)
    case orderImage(jbCustomerId: String, season: String, imagePathType: ImagePathType)
}

extension SellerImageService: CollectionServiceType {

    var order: String {
        switch self {
        case .buyingImage(_, _, _), .sellerImage(_, _, _), .workerImage(_, _, _), .otherImage(_, _, _), .orderImage(_, _, _):

            return "date"
        }
    }

    var storageReference: StorageReference {
        switch self {
        case .buyingImage(let sellerId, let season, let imagePathType):

            return Storage
                .storage()
                .reference()
                .child("seller")
                .child(sellerId)
                .child(season)
                .child("\(imagePathType.rawValue)/\(Date().dateFormatterApiResponseType()).jpg")

        case .sellerImage(let customerId, let season, let imagePathType):

            return Storage
                .storage()
                .reference()
                .child("customer")
                .child(customerId)
                .child(season)
                .child("\(imagePathType.rawValue)/\(Date().dateFormatterApiResponseType()).jpg")

        case .workerImage(let cavusId, let season, let imagePathType):
            return Storage
                .storage()
                .reference()
                .child("cavus")
                .child(cavusId)
                .child(season)
                .child("\(imagePathType.rawValue)/\(Date().dateFormatterApiResponseType()).jpg")

        case .otherImage(let otherSellerId, let season, let imagePathType):
            return Storage
                .storage()
                .reference()
                .child("otherSeller")
                .child(otherSellerId)
                .child(season)
                .child("\(imagePathType.rawValue)/\(Date().dateFormatterApiResponseType()).jpg")

        case .orderImage(let jbCustomerId, let season, let imagePathType):
            return Storage
                .storage()
                .reference()
                .child(jobiCollection)
                .child(jobiUuid)
                .child("order")
                .child(jbCustomerId)
                .child(season)
                .child("\(imagePathType.rawValue)/\(Date().dateFormatterApiResponseType()).jpg")
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .buyingImage(let sellerId, let season, let imagePathType):

            return Firestore
                .firestore()
                .collection("seller")
                .document(sellerId)
                .collection(season)
                .document("images")
                .collection(imagePathType.rawValue)

        case .sellerImage(let customerId, let season, let imagePathType):

            return Firestore
                .firestore()
                .collection("customer")
                .document(customerId)
                .collection(season)
                .document("images")
                .collection(imagePathType.rawValue)

        case .workerImage(let cavusId, let season, let imagePathType):

            return Firestore
                .firestore()
                .collection("cavus")
                .document(cavusId)
                .collection(season)
                .document("images")
                .collection(imagePathType.rawValue)

        case .otherImage(let otherSellerId, let season, let imagePathType):

            return Firestore
                .firestore()
                .collection("otherSeller")
                .document(otherSellerId)
                .collection(season)
                .document("images")
                .collection(imagePathType.rawValue)

        case .orderImage(let jbCustomerId, let season, let imagePathType):

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("jobiCustomer")
                .document(jbCustomerId)
                .collection("data")
                .document(season)
                .collection("images")
                .document("archive")
                .collection(imagePathType.rawValue)
        }
    }
}
