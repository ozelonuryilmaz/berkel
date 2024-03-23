//
//  StockRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import FirebaseFirestore

protocol IJobiStockRepository: AnyObject {

    func saveNewStockCategory(season: StockModel) -> FirestoreResponseType<StockModel>
}

final class JobiStockRepository: BaseRepository, IJobiStockRepository {

    func saveNewStockCategory(season: StockModel) -> FirestoreResponseType<StockModel> {
        let db: DocumentReference = JobiStockService.save.collectionReference.document()
        return self.setData(db, data: season)
    }
}
