//
//  OrderDetailRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation

protocol IOrderDetailRepository: AnyObject {
    func getCollection(season: String, customerId: String, orderId: String) -> FirestoreResponseType<[OrderCollectionModel]>
    func getPayment(season: String, customerId: String, orderId: String) -> FirestoreResponseType<[OrderPaymentModel]>
    func updateCollectionCalc(season: String, customerId: String, orderId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool>
    func updateFaturaNo(season: String, customerId: String, orderId: String, collectionId: String, faturaNo: String) -> FirestoreResponseType<Bool>
    func updateFaturaNo(season: String, customerId: String, orderId: String, paymentId: String, faturaNo: String) -> FirestoreResponseType<Bool>
    func updateBuyingActive(season: String, orderId: String, isActive: Bool) -> FirestoreResponseType<Bool>
    func deletePayment(season: String, customerId: String, orderId: String, paymentId: String) -> FirestoreResponseType<Bool>
    func deleteCollection(season: String, customerId: String, orderId: String, collectionId: String) -> FirestoreResponseType<Bool>
}

final class OrderDetailRepository: BaseRepository, IOrderDetailRepository {

    func getCollection(season: String, customerId: String, orderId: String) -> FirestoreResponseType<[OrderCollectionModel]> {
        let db = OrderService.customerCollections(season: season, customerId: customerId, orderId: orderId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, customerId: String, orderId: String) -> FirestoreResponseType<[OrderPaymentModel]> {
        let db = OrderService.customerPayments(season: season, customerId: customerId, orderId: orderId)
        return getDocuments(db, order: db.order)
    }

    func updateCollectionCalc(season: String, customerId: String, orderId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool> {
        let db = OrderService.customerCollection(season: season, customerId: customerId, orderId: orderId, collectionId: collectionId).documentReference
        return updateData(db, data: ["isCalc": isCalc])
    }

    func updateBuyingActive(season: String, orderId: String, isActive: Bool) -> FirestoreResponseType<Bool> {
        let db = OrderService.orderDetail(season: season, orderId: orderId).documentReference
        return updateData(db, data: ["isActive": isActive])
    }

    func updateFaturaNo(season: String, customerId: String, orderId: String, collectionId: String, faturaNo: String) -> FirestoreResponseType<Bool> {
        let db = OrderService.customerCollection(season: season, customerId: customerId, orderId: orderId, collectionId: collectionId).documentReference
        return updateData(db, data: ["faturaNo": faturaNo])
    }
    
    func updateFaturaNo(season: String, customerId: String, orderId: String, paymentId: String, faturaNo: String) -> FirestoreResponseType<Bool> {
        let db = OrderService.customerPayment(season: season, customerId: customerId, orderId: orderId, paymentId: paymentId).documentReference
        return updateData(db, data: ["faturaNo": faturaNo])
    }

    func deletePayment(season: String, customerId: String, orderId: String, paymentId: String) -> FirestoreResponseType<Bool> {
        let db = OrderService.customerPayment(season: season, customerId: customerId, orderId: orderId, paymentId: paymentId).documentReference
        return deleteData(db)
    }

    func deleteCollection(season: String, customerId: String, orderId: String, collectionId: String) -> FirestoreResponseType<Bool> {
        let db = OrderService.customerCollection(season: season, customerId: customerId, orderId: orderId, collectionId: collectionId).documentReference
        return deleteData(db)
    }
}
