//
//  StockService.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import FirebaseFirestore

enum JobiStockService {

    case stocks(season: String) // Limonata, Nar, ...
    case subStocks(season: String, stokId: String) // 0.33lt, 0.5lt, ...
    case stockList(season: String)
}

extension JobiStockService: CollectionServiceType {

    var order: String {
        switch self {
        case .stockList(_):
            return "date"
        default:
            return ""
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .stockList(let season):

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")

            
        case .stocks(let season):

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")

        case .subStocks(let season, let stokId):

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")
                .document(stokId)
                .collection("subStocks")
        }
    }
}
