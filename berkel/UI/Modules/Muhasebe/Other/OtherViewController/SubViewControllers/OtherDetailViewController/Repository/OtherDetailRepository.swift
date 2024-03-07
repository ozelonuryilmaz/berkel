//
//  OtherDetailRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import Foundation

protocol IOtherDetailRepository: AnyObject {

    func getCollection(season: String, otherId: String) -> FirestoreResponseType<[OtherCollectionModel]>
    func getPayment(season: String, otherId: String) -> FirestoreResponseType<[OtherPaymentModel]>

    func updateCollectionCalc(season: String, otherId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool>
    func updateBuyingActive(season: String, otherId: String, isActive: Bool) -> FirestoreResponseType<Bool>
    
    func deletePayment(season: String, otherId: String, paymentId: String) -> FirestoreResponseType<Bool>
}

final class OtherDetailRepository: BaseRepository, IOtherDetailRepository {

    func getCollection(season: String, otherId: String) -> FirestoreResponseType<[OtherCollectionModel]> {
        let db = OtherService.collection(season: season, otherId: otherId)
        return getDocuments(db, order: db.order)
    }
    
    func getPayment(season: String, otherId: String) -> FirestoreResponseType<[OtherPaymentModel]> {
        let db = OtherService.payment(season: season, otherId: otherId)
        return getDocuments(db, order: db.order)
    }

    func updateCollectionCalc(season: String, otherId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool> {
        let db = OtherService.other(season: season, otherId: otherId, collectionId: collectionId).documentReference
        return updateData(db, data: ["isCalc": isCalc])
    }
    
    func updateBuyingActive(season: String, otherId: String, isActive: Bool) -> FirestoreResponseType<Bool> {
        let db = OtherService.collection(season: season, otherId: otherId).documentReference
        return updateData(db, data: ["isActive": isActive])
    }
    
    func deletePayment(season: String, otherId: String, paymentId: String) -> FirestoreResponseType<Bool> {
        let db = OtherService.deletePayment(season: season, otherId: otherId, paymentId: paymentId).documentReference
        return deleteData(db)
    }
    
}
