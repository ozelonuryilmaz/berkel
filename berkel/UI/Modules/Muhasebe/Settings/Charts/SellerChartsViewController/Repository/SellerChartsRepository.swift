//
//  SellerChartsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.12.2023.
//

import FirebaseFirestore

protocol ISellerChartsRepository: AnyObject {

    func getList(season: String) -> FirestoreResponseType<[SellerModel]>
    func getCollection(season: String, sellerId: String) -> FirestoreResponseType<[SellerCollectionModel]>
    func getPayment(season: String, sellerId: String) -> FirestoreResponseType<[SellerPaymentModel]>
}

final class SellerChartsRepository: BaseRepository, ISellerChartsRepository {

    func getList(season: String) -> FirestoreResponseType<[SellerModel]> {
        let db = SellerService.list(season: season)
        return getDocuments(db, order: db.order)
    }

    func getCollection(season: String, sellerId: String) -> FirestoreResponseType<[SellerCollectionModel]> {
        let db = SellerService.collection(season: season, sellerId: sellerId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, sellerId: String) -> FirestoreResponseType<[SellerPaymentModel]> {
        let db = SellerService.payment(season: season, sellerId: sellerId)
        return getDocuments(db, order: db.order)
    }
}
