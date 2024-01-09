//
//  BuyingChartsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.01.2024.
//

import Foundation

protocol IBuyingChartsRepository: AnyObject {

    func getList(season: String) -> FirestoreResponseType<[NewBuyingModel]>
    func getCollection(season: String, buyingId: String) -> FirestoreResponseType<[BuyingCollectionModel]>
    func getPayment(season: String, buyingId: String) -> FirestoreResponseType<[NewBuyingPaymentModel]>
    func getWarehouseList(season: String, buyingId: String, collectionId: String) -> FirestoreResponseType<[WarehouseModel]>
}

final class BuyingChartsRepository: BaseRepository, IBuyingChartsRepository {

    func getList(season: String) -> FirestoreResponseType<[NewBuyingModel]> {
        let db = NewBuyingService.list(season: season)
        return getDocuments(db, order: db.order)
    }
    
    func getCollection(season: String, buyingId: String) -> FirestoreResponseType<[BuyingCollectionModel]> {
        let db = BuyingDataService.collection(season: season, buyingId: buyingId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, buyingId: String) -> FirestoreResponseType<[NewBuyingPaymentModel]> {
        let db = BuyingDataService.payment(season: season, buyingId: buyingId)
        return getDocuments(db, order: db.order)
    }

    func getWarehouseList(season: String, buyingId: String, collectionId: String) -> FirestoreResponseType<[WarehouseModel]> {
        let db = BuyingDataService.wavehouse(season: season, buyingId: buyingId, collectionId: collectionId)
        return getDocuments(db, order: db.order)
    }
}
