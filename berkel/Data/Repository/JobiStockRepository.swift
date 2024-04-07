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
    func getSubStock(season: String, stockId: String) -> FirestoreResponseType<[SubStockModel]>
    func saveStockInfo(season: String, stockId: String, subStockId: String, data: UpdateStockModel) -> FirestoreResponseType<UpdateStockModel>
    func getStockInfo(cursor: [String]?, limit: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<[UpdateStockModel]>
    func updateStockCount(count: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<Bool>
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
        let db: DocumentReference = JobiStockService.subStocks(season: season,
                                                               stockId: stockId).collectionReference.document()
        let key = db.documentID
        var tempData = data
        tempData.id = key
        return self.setData(db, data: tempData)
    }
    
    func getStock(season: String) -> FirestoreResponseType<[StockModel]> {
        return getDocuments(JobiStockService.stockList(season: season),
                            order: JobiStockService.stockList(season: season).order)
    }
    
    func getSubStock(season: String, stockId: String) -> FirestoreResponseType<[SubStockModel]> {
        return getDocuments(JobiStockService.subStockList(season: season, stockId: stockId),
                            order: JobiStockService.subStockList(season: season, stockId: stockId).order)
    }
    
    func getStockInfo(cursor: [String]?, limit: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<[UpdateStockModel]> {
        let db = JobiStockService.stockInfo(season: season, stockId: stockId, subStockId: subStockId)
        return getDocuments(db,
                            order: db.order,
                            cursor: cursor,
                            limit: limit)
    }
    
    func saveStockInfo(season: String, stockId: String, subStockId: String, data: UpdateStockModel) -> FirestoreResponseType<UpdateStockModel> {
        let db: DocumentReference = JobiStockService.stockInfo(season: season,
                                                               stockId: stockId,
                                                               subStockId: subStockId).collectionReference.document()
        let key = db.documentID
        var tempData = data
        tempData.id = key
        return self.setData(db, data: tempData)
    }
    
    func updateStockCount(count: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<Bool> {
        return updateStockCount(JobiStockService.subStock(season: season, stockId: stockId, subStockId: subStockId).documentReference, count: count)
    }
}
