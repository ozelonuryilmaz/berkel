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
    func getStocks(season: String) -> FirestoreResponseType<[StockModel]>
    func getSubStocks(season: String, stockId: String) -> FirestoreResponseType<[SubStockModel]>
    func getSubStock(season: String, stockId: String, subStockId: String) -> FirestoreResponseType<SubStockModel>
    func saveSubStockInfo(season: String, stockId: String, subStockId: String, data: UpdateStockModel) -> FirestoreResponseType<UpdateStockModel>
    func getSubStockInfos(cursor: [String]?, limit: Int?, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<[UpdateStockModel]>
    func updateSubStockCountWithTransaction(count: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<Bool>
    func updateSubStockCount(count: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<Bool>
    func updateStockDate(season: String, stockId: String, date: String) -> FirestoreResponseType<Bool>
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

    func getStocks(season: String) -> FirestoreResponseType<[StockModel]> {
        let db = JobiStockService.stocks(season: season)
        return getDocuments(db, order: db.order)
    }

    func getSubStocks(season: String, stockId: String) -> FirestoreResponseType<[SubStockModel]> {
        let db = JobiStockService.subStocks(season: season, stockId: stockId)
        return getDocuments(db, order: db.order)
    }

    func getSubStock(season: String, stockId: String, subStockId: String) -> FirestoreResponseType<SubStockModel> {
        let db = JobiStockService.subStock(season: season, stockId: stockId, subStockId: subStockId)
        return getDocument(db)
    }

    func getSubStockInfos(cursor: [String]?, limit: Int?, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<[UpdateStockModel]> {
        let db = JobiStockService.subStockInfo(season: season, stockId: stockId, subStockId: subStockId)
        return getDocuments(db,
                            order: db.order,
                            cursor: cursor,
                            limit: limit)
    }

    func saveSubStockInfo(season: String, stockId: String, subStockId: String, data: UpdateStockModel) -> FirestoreResponseType<UpdateStockModel> {
        let db: DocumentReference = JobiStockService.subStockInfo(season: season,
                                                               stockId: stockId,
                                                               subStockId: subStockId).collectionReference.document()
        let key = db.documentID
        var tempData = data
        tempData.id = key
        return self.setData(db, data: tempData)
    }

    func updateSubStockCountWithTransaction(count: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<Bool> {
        return updateStockCount(JobiStockService.subStock(season: season, stockId: stockId, subStockId: subStockId).documentReference, count: count)
    }

    func updateSubStockCount(count: Int, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<Bool> {
        let db = JobiStockService.subStock(season: season, stockId: stockId, subStockId: subStockId).documentReference
        return updateData(db, data: ["counter": count])
    }
    
    func updateStockDate(season: String, stockId: String, date: String) -> FirestoreResponseType<Bool> {
        let db = JobiStockService.stock(season: season, stockId: stockId).documentReference
        return updateData(db, data: ["date": date])
    }
}
