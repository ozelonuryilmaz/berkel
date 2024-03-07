//
//  NewWarehouseRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import FirebaseFirestore

protocol INewWarehouseRepository: AnyObject {

    func saveNewWarehouse(season: String,
                          buyingId: String,
                          collectionId: String,
                          data: WarehouseModel) -> FirestoreResponseType<WarehouseModel>
}

final class NewWarehouseRepository: BaseRepository, INewWarehouseRepository {

    func saveNewWarehouse(season: String,
                          buyingId: String,
                          collectionId: String,
                          data: WarehouseModel) -> FirestoreResponseType<WarehouseModel> {

        let db: DocumentReference = BuyingDataService.wavehouse(season: season, buyingId: buyingId, collectionId: collectionId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
