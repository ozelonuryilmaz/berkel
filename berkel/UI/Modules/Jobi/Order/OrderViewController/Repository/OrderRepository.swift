//
//  OrderRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Foundation

protocol IOrderRepository: AnyObject {
    func getOrderList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[OrderModel]>
}

final class OrderRepository: BaseRepository, IOrderRepository {

    func getOrderList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[OrderModel]> {
        let db = OrderService.order(season: season)
        return getDocuments(
            db,
            order: db.order,
            cursor: cursor,
            limit: limit
        )
    }
}
