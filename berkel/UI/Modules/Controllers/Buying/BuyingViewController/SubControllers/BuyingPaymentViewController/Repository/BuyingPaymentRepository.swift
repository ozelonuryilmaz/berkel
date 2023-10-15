//
//  BuyingPaymentRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import FirebaseFirestore

protocol IBuyingPaymentRepository: AnyObject {

    func saveNewPayment(season: String,
                        buyingId: String,
                        data: NewBuyingPaymentModel) -> FirestoreResponseType<NewBuyingPaymentModel>
}

final class BuyingPaymentRepository: BaseRepository, IBuyingPaymentRepository {

    func saveNewPayment(season: String,
                        buyingId: String,
                        data: NewBuyingPaymentModel) -> FirestoreResponseType<NewBuyingPaymentModel> {

        let db: DocumentReference = BuyingCollectionService.savePayment(season: season, buyingId: buyingId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
