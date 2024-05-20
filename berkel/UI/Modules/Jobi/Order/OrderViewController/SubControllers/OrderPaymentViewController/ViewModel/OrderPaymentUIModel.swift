//
//  OrderPaymentUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IOrderPaymentUIModel {

    var season: String { get }

    var data: OrderPaymentModel { get }
    var customerName: String { get }
    var payment: Double { get }

    init(data: OrderPaymentPassData)

    mutating func setDate(date: String?)
    mutating func setPayment(_ text: String)
    mutating func setFaturaNo(_ text: String)
    mutating func setDesc(_ text: String)
}

struct OrderPaymentUIModel: IOrderPaymentUIModel {

    // MARK: Definitions
    private let orderModel: OrderModel

    // MARK: Initialize
    init(data: OrderPaymentPassData) {
        self.orderModel = data.orderModel
    }

    var date: String? = Date().dateFormatterApiResponseType()
    var payment: Double = 0.0
    var faturaNo: String? = nil
    var desc: String? = nil

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var orderId: String? {
        return orderModel.id
    }

    // JB Customer
    var customerId: String? {
        return orderModel.jbCustomerId
    }

    var customerName: String {
        return orderModel.jbCustomerName
    }

    var data: OrderPaymentModel {
        return OrderPaymentModel(id: nil,
                                 orderId: orderId,
                                 userId: userId,
                                 customerId: customerId,
                                 customerName: customerName,
                                 date: date,
                                 payment: payment,
                                 faturaNo: faturaNo?.uppercased(with: Locale(identifier: "tr")),
                                 description: desc)
    }

    // MARK: Computed Props
}

// MARK: Props
extension OrderPaymentUIModel {

}

// MARK: Setter
extension OrderPaymentUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setPayment(_ text: String) {
        self.payment = Double(text) ?? 0.0
    }

    mutating func setFaturaNo(_ text: String) {
        self.faturaNo = text
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }
}
