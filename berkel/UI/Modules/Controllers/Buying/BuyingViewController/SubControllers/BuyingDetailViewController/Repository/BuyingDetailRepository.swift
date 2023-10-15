//
//  BuyingDetailRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

protocol IBuyingDetailRepository: AnyObject {
    func getCollection(season: String, buyingId: String) -> FirestoreResponseType<[BuyingCollectionModel]>
    func getPayment(season: String, buyingId: String) -> FirestoreResponseType<[NewBuyingPaymentModel]>
}

final class BuyingDetailRepository: BaseRepository, IBuyingDetailRepository {

    func getCollection(season: String, buyingId: String) -> FirestoreResponseType<[BuyingCollectionModel]> {
        let db = BuyingDataService.collection(season: season, buyingId: buyingId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, buyingId: String) -> FirestoreResponseType<[NewBuyingPaymentModel]> {
        let db = BuyingDataService.payment(season: season, buyingId: buyingId)
        return getDocuments(db, order: db.order)
    }
}
