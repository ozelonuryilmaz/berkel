//
//  OtherSellerChartsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import Foundation

protocol IOtherSellerChartsRepository: AnyObject {

    func getList(season: String) -> FirestoreResponseType<[OtherModel]>
    func getCollection(season: String, otherId: String) -> FirestoreResponseType<[OtherCollectionModel]>
    func getPayment(season: String, otherId: String) -> FirestoreResponseType<[OtherPaymentModel]>
}

final class OtherSellerChartsRepository: BaseRepository, IOtherSellerChartsRepository {

    func getList(season: String) -> FirestoreResponseType<[OtherModel]> {
        let db = OtherService.list(season: season)
        return getDocuments(db, order: db.order)
    }

    func getCollection(season: String, otherId: String) -> FirestoreResponseType<[OtherCollectionModel]> {
        let db = OtherService.collection(season: season, otherId: otherId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, otherId: String) -> FirestoreResponseType<[OtherPaymentModel]> {
        let db = OtherService.payment(season: season, otherId: otherId)
        return getDocuments(db, order: db.order)
    }
}
