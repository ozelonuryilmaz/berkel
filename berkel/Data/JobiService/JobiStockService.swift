//
//  StockService.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import FirebaseFirestore

enum JobiStockService {

    case stocks(season: String) // Limonata, Nar, ...
    case subStocks(season: String, stockId: String) // 0.33lt, 0.5lt, ...
    case subStock(season: String, stockId: String, subStockId: String)
    case stockList(season: String)
    case stockInfo(season: String, stockId: String, subStockId: String)
    case subStockList(season: String, stockId: String)
}

extension JobiStockService: CollectionServiceType {

    var order: String {
        switch self {
        case .stockList(_), .subStockList(_,_):
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
            
        case .subStockList(let season, let stockId):

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")
                .document(stockId)
                .collection("subStocks")

        case .stocks(let season):

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")

        case .subStocks(let season, let stockId):

            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")
                .document(stockId)
                .collection("subStocks")
            
        case .stockInfo(let season,let stockId,let subStockId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")
                .document(stockId)
                .collection("subStocks")
                .document(subStockId)
                .collection("stockInfo")
            
        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}

extension JobiStockService: DocumentServiceType {
    
    var documentReference: DocumentReference {
        switch self {
    
        case .subStock(let season,let stockId,let subStockId):
            return Firestore
                .firestore()
                .collection(jobiCollection)
                .document(jobiUuid)
                .collection("data")
                .document(season)
                .collection("stocks")
                .document(stockId)
                .collection("subStocks")
                .document(subStockId)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }
}
