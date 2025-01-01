//
//  JBCustomerHistoryRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation

protocol IJBCustomerHistoryRepository: AnyObject {
    func getOrderList(season: String) -> FirestoreResponseType<[OrderModel]>
    func getCollection(season: String, customerId: String, orderId: String) -> FirestoreResponseType<[OrderCollectionModel]>
}

final class JBCustomerHistoryRepository: BaseRepository, IJBCustomerHistoryRepository {
    
    func getOrderList(season: String) -> FirestoreResponseType<[OrderModel]> {
        let db = OrderService.order(season: season)
        return getDocuments(db, order: db.order)
    }
    
    func getCollection(season: String, customerId: String, orderId: String) -> FirestoreResponseType<[OrderCollectionModel]> {
        let db = OrderService.customerCollections(season: season, customerId: customerId, orderId: orderId)
        return getDocuments(db, order: db.order)
    }
}
