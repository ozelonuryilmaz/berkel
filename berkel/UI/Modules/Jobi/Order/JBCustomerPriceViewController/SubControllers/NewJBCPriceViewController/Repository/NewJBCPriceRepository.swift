//
//  NewJBCPriceRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import FirebaseFirestore

protocol INewJBCPriceRepository: AnyObject {
    func savePrice(data: JBCPriceModel, season: String) -> FirestoreResponseType<JBCPriceModel>
}

final class NewJBCPriceRepository: BaseRepository, INewJBCPriceRepository {

    func savePrice(data: JBCPriceModel, season: String) -> FirestoreResponseType<JBCPriceModel> {
        let db: DocumentReference = JBCustomerService
            .prices(customerId: data.customerId ?? "",
                    season: season,
                    stockId: data.stockId ?? "",
                    subStockId: data.subStockId ?? "")
            .collectionReference.document()

        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
