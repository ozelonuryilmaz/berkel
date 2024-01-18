//
//  SellerDetailRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import FirebaseFirestore

protocol ISellerDetailRepository: AnyObject {

    func getCollection(season: String, sellerId: String) -> FirestoreResponseType<[SellerCollectionModel]>
    func getPayment(season: String, sellerId: String) -> FirestoreResponseType<[SellerPaymentModel]>

    func updateCollectionCalc(season: String, sellerId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool>
    func updateBuyingActive(season: String, sellerId: String, isActive: Bool) -> FirestoreResponseType<Bool>
    
    func deletePayment(season: String, sellerId: String, paymentId: String) -> FirestoreResponseType<Bool>
}

final class SellerDetailRepository: BaseRepository, ISellerDetailRepository {

    func getCollection(season: String, sellerId: String) -> FirestoreResponseType<[SellerCollectionModel]> {
        let db = SellerService.collection(season: season, sellerId: sellerId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, sellerId: String) -> FirestoreResponseType<[SellerPaymentModel]> {
        let db = SellerService.payment(season: season, sellerId: sellerId)
        return getDocuments(db, order: db.order)
    }

    func updateCollectionCalc(season: String, sellerId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool> {
        let db = SellerService.seller(season: season, sellerId: sellerId, collectionId: collectionId).documentReference
        return updateData(db, data: ["isCalc": isCalc])
    }

    func updateBuyingActive(season: String, sellerId: String, isActive: Bool) -> FirestoreResponseType<Bool> {
        let db = SellerService.collection(season: season, sellerId: sellerId).documentReference
        return updateData(db, data: ["isActive": isActive])
    }
    
    func deletePayment(season: String, sellerId: String, paymentId: String) -> FirestoreResponseType<Bool> {
        let db = SellerService.deletePayment(season: season, sellerId: sellerId, paymentId: paymentId).documentReference
        return deleteData(db)
    }
}
