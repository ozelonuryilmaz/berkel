//
//  NewBuyingRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import FirebaseFirestore

protocol INewBuyingRepository: AnyObject {

    func saveNewBuying(data: NewBuyingModel, season: String) -> FirestoreResponseType<NewBuyingModel>
    func savePayment(data: NewBuyingPaymentModel, season: String, buyingId: String) -> FirestoreResponseType<NewBuyingPaymentModel>
}

final class NewBuyingRepository: BaseRepository, INewBuyingRepository {

    func saveNewBuying(data: NewBuyingModel, season: String) -> FirestoreResponseType<NewBuyingModel> {
        let db: DocumentReference = NewBuyingService.save(season: season).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }

    func savePayment(data: NewBuyingPaymentModel, season: String, buyingId: String) -> FirestoreResponseType<NewBuyingPaymentModel> {
        let db: DocumentReference = NewBuyingService.saveFirstPayment(season: season, buyingId: buyingId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
