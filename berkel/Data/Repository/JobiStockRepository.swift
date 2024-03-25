//
//  StockRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import FirebaseFirestore

protocol IJobiStockRepository: AnyObject {

    func saveStock(season: String, data: StockModel) -> FirestoreResponseType<StockModel>
    func saveSubStock(season: String, stockId: String, data: SubStockModel) -> FirestoreResponseType<SubStockModel>
    func getStock(season: String) -> FirestoreResponseType<[StockModel]>
}

final class JobiStockRepository: BaseRepository, IJobiStockRepository {

    func saveStock(season: String, data: StockModel) -> FirestoreResponseType<StockModel> {
        let db: DocumentReference = JobiStockService.stocks(season: season).collectionReference.document()
        let key = db.documentID
        var tempData = data
        tempData.id = key
        return self.setData(db, data: tempData)
    }
    
    func saveSubStock(season: String, stockId: String, data: SubStockModel) -> FirestoreResponseType<SubStockModel> {
        let db: DocumentReference = JobiStockService.subStocks(season: season, stokId: stockId).collectionReference.document()
        let key = db.documentID
        var tempData = data
        tempData.id = key
        return self.setData(db, data: tempData)
    }
    
    func getStock(season: String) -> FirestoreResponseType<[StockModel]> {
        return getDocuments(JobiStockService.stockList(season: season),
                            order: JobiStockService.stockList(season: season).order)
    }
}
