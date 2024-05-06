//
//  OrderDetailCollectionTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import Foundation

protocol IOrderDetailCollectionTableViewCellUIModel {

    var orderModel: OrderModel? { get }
    var orderCollectionModel: OrderCollectionModel? { get }

    var orderId: String? { get }
    var collectionId: String? { get }
    var isCalc: Bool { get }
    var isActive: Bool { get }

    var date: String { get }
    var count: String { get }
    var orderName: String { get }

    var isVisibleButtons: Bool { get }
}

struct OrderDetailCollectionTableViewCellUIModel: IOrderDetailCollectionTableViewCellUIModel {

    let orderModel: OrderModel?
    let orderCollectionModel: OrderCollectionModel?

    let orderId: String?
    let collectionId: String?
    let isCalc: Bool
    let isActive: Bool

    let date: String
    var count: String
    var orderName: String

    // Seller Charts için eklendi
    let isVisibleButtons: Bool
}
