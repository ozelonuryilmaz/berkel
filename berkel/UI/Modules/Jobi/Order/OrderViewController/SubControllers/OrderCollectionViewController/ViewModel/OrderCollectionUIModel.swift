//
//  OrderCollectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IOrderCollectionUIModel {

    var season: String { get }
    
    var customerId: String? { get }
    var customerName: String { get }
    var productName: String { get }
    var productPrice: String { get }
    
    var stockId: String? { get }
    var subStockId: String? { get }

    var data: OrderCollectionModel { get }
    var stockData: UpdateStockModel { get }

    var errorMessage: String? { get }

    init(data: OrderCollectionPassData)
    
    func getCount() -> Int

    mutating func setStockModel(_ stockModel: StockModel)
    mutating func setSubStockModel(_ subStockModel: SubStockModel)
    mutating func setPrice(_ price: Double)

    mutating func setCount(_ count: String)
    mutating func setKDV(_ kdv: String)
    mutating func setDesc(_ desc: String)
}

struct OrderCollectionUIModel: IOrderCollectionUIModel {

    // MARK: Definitions
    private let orderModel: OrderModel

    private var stockModel: StockModel? = nil
    private var subStockModel: SubStockModel? = nil

    private var price: Double = 0.0

    private var count: Int = 0
    private var kdv: Int = 0
    private var desc: String? = nil

    // MARK: Initialize
    init(data: OrderCollectionPassData) {
        self.orderModel = data.orderModel
    }

    // MARK: Computed Props

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var orderId: String? {
        return orderModel.id
    }

    // Stock
    var stockId: String? {
        return stockModel?.id
    }

    var stockName: String {
        return stockModel?.stockName ?? ""
    }

    // Sub Stock
    var subStockId: String? {
        return subStockModel?.id
    }

    var subStockName: String {
        return subStockModel?.subStockName ?? ""
    }

    // JB Customer
    var customerId: String? {
        return orderModel.jbCustomerId
    }

    var customerName: String {
        return orderModel.jbCustomerName
    }

    // UI
    var productName: String {
        return "\(stockName) - \(subStockName)"
    }

    var productPrice: String {
        return price.decimalString() + " TL"
    }
    
    private var stockDesc: String {
        return "\(customerName) müşteri siparişi"
    }

    var data: OrderCollectionModel {
        return OrderCollectionModel(id: nil,
                                    orderId: orderId,
                                    userId: userId,
                                    stockId: stockId,
                                    subStockId: subStockId,
                                    customerId: customerId,
                                    stockName: stockName,
                                    subStockName: subStockName,
                                    customerName: customerName,
                                    count: count,
                                    price: price,
                                    kdv: kdv,
                                    desc: desc,
                                    date: Date().dateFormatterApiResponseType())
    }
    
    var stockData: UpdateStockModel {
        return UpdateStockModel(stockId: stockId,
                                subStockId: subStockId,
                                userId: userId,
                                count: getCount(),
                                date: Date().dateFormatterApiResponseType(),
                                desc: stockDesc,
                                type: UpdateStockType.remove.rawValue)
    }

    var errorMessage: String? {
        if stockModel == nil {
            return "Lütfen ürün ve fiyat seçiniz"
        }

        if count <= 0 {
            return "Lütfen ürün adeti giriniz"
        }

        if (desc?.count ?? 0) < 3 {
            return "Lütfen açıklama yazınız"
        }

        return nil
    }
    
    // Stoktan düşürüleceği için -1 ile çarpıldı
    func getCount() -> Int {
        return self.count * (-1)
    }
}

// MARK: Setter
extension OrderCollectionUIModel {

    mutating func setStockModel(_ stockModel: StockModel) {
        self.stockModel = stockModel
    }

    mutating func setSubStockModel(_ subStockModel: SubStockModel) {
        self.subStockModel = subStockModel
    }

    mutating func setPrice(_ price: Double) {
        self.price = price
    }

    mutating func setCount(_ count: String) {
        self.count = Int(count) ?? 0
    }

    mutating func setKDV(_ kdv: String) {
        self.kdv = Int(kdv) ?? 00
    }

    mutating func setDesc(_ desc: String) {
        self.desc = desc
    }
}
