//
//  NewWarehouseRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
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
