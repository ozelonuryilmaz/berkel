//
//  NewJBCPriceUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol INewJBCPriceUIModel {

    var navTitle: String { get }

    var data: JBCPriceModel { get }
    var season: String { get }
    var stockId: String { get }
    var subStockId: String { get }

    var errorMessage: String? { get }

    init(data: NewJBCPricePassData)

    mutating func setDate(date: String?)
    mutating func setCount(_ text: String)
    mutating func setDesc(_ text: String)
}

struct NewJBCPriceUIModel: INewJBCPriceUIModel {

    // MARK: Definitions
    private let customerModel: JBCustomerModel
    private let stockModel: StockModel
    private let subStockModel: SubStockModel

    private var date: String? = Date().dateFormatterApiResponseType()
    private var count: Double = 0.0
    private var desc: String? = nil

    // MARK: Initialize
    init(data: NewJBCPricePassData) {
        self.customerModel = data.customerModel
        self.stockModel = data.stockModel
        self.subStockModel = data.subStockModel
    }

    // MARK: Computed Props
    var navTitle: String {
        return "\(stockModel.stockName) - \(subStockModel.subStockName)"
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var userId: String? {
        return UserManager.shared.userId
    }

    var stockId: String {
        return stockModel.id ?? ""
    }

    var subStockId: String {
        return subStockModel.id ?? ""
    }

    var data: JBCPriceModel {
        return JBCPriceModel(id: nil,
                             userId: userId,
                             stockId: stockModel.id,
                             stockName: stockModel.stockName,
                             subStockId: subStockModel.id,
                             subStockName: subStockModel.subStockName,
                             customerId: customerModel.id,
                             customerName: customerModel.name, 
                             isActive: true,
                             date: date,
                             price: count,
                             desc: desc ?? "")
    }

    var errorMessage: String? {
        if count == 0.0 {
            return "Lütfen adet fiyatını giriniz"
        }

        return nil
    }


}

// MARK: Props
extension NewJBCPriceUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setCount(_ text: String) {
        self.count = Double(text) ?? 0.0
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }
}
