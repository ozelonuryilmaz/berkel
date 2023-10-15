//
//  BuyingCollectionRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import FirebaseFirestore

protocol IBuyingCollectionRepository: AnyObject {

    func saveNewCollection(season: String,
                           buyingId: String,
                           data: BuyingCollectionModel) -> FirestoreResponseType<BuyingCollectionModel>
}

final class BuyingCollectionRepository: BaseRepository, IBuyingCollectionRepository {

    func saveNewCollection(season: String,
                           buyingId: String,
                           data: BuyingCollectionModel) -> FirestoreResponseType<BuyingCollectionModel> {

        let db: DocumentReference = BuyingDataService.collection(season: season, buyingId: buyingId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
