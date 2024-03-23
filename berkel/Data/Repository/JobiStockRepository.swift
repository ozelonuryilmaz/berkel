//
//  StockRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import FirebaseFirestore

protocol IJobiStockRepository: AnyObject {

    func saveStock(season: String, data: StockModel) -> FirestoreResponseType<StockModel>
}

final class JobiStockRepository: BaseRepository, IJobiStockRepository {

    func saveStock(season: String, data: StockModel) -> FirestoreResponseType<StockModel> {
        let db: DocumentReference = JobiStockService.stocks(season: season).collectionReference.document()
        let key = db.documentID
        var tempData = data
        tempData.id = key
        return self.setData(db, data: tempData)
    }
}
