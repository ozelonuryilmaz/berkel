//
//  BuyingDetailRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//

import FirebaseFirestore

protocol IBuyingDetailRepository: AnyObject {
    func getCollection(season: String, buyingId: String) -> FirestoreResponseType<[BuyingCollectionModel]>
    func getPayment(season: String, buyingId: String) -> FirestoreResponseType<[NewBuyingPaymentModel]>
    func getWarehouseList(season: String, buyingId: String, collectionId: String) -> FirestoreResponseType<[WarehouseModel]>

    func updateCollectionCalc(season: String, buyingId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool>
    func updateBuyingActive(season: String, buyingId: String, isActive: Bool) -> FirestoreResponseType<Bool>

    func deletePayment(season: String, buyingId: String, paymentId: String) -> FirestoreResponseType<Bool>
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

    func getWarehouseList(season: String, buyingId: String, collectionId: String) -> FirestoreResponseType<[WarehouseModel]> {
        let db = BuyingDataService.wavehouse(season: season, buyingId: buyingId, collectionId: collectionId)
        return getDocuments(db, order: db.order)
    }

    func updateCollectionCalc(season: String, buyingId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool> {
        let db = BuyingDataService.wavehouse(season: season, buyingId: buyingId, collectionId: collectionId).documentReference
        return updateData(db, data: ["isCalc": isCalc])
    }

    func updateBuyingActive(season: String, buyingId: String, isActive: Bool) -> FirestoreResponseType<Bool> {
        let db = BuyingDataService.collection(season: season, buyingId: buyingId).documentReference
        return updateData(db, data: ["isActive": isActive])
    }

    func deletePayment(season: String, buyingId: String, paymentId: String) -> FirestoreResponseType<Bool> {
        let db: DocumentReference = BuyingDataService.deletePayment(season: season, buyingId: buyingId, paymentId: paymentId).documentReference
        return deleteData(db)
    }
}
