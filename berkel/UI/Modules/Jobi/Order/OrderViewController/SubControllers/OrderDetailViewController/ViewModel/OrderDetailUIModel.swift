//
//  OrderDetailUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IOrderDetailUIModel {

    var season: String { get }

    var orderId: String { get }
    var customerName: String { get }
    var customerId: String { get }
    var isActive: Bool { get }

    var collections: [OrderCollectionModel] { get }

    init(data: OrderDetailPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setActive(isActive: Bool)

    mutating func setCollectionResponse(data: [OrderCollectionModel])
    mutating func setPaymentResponse(data: [OrderPaymentModel])

    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool)

    func getCollection(orderId: String?) -> OrderCollectionModel?

    // Collection
    mutating func buildCollectionSnapshot() -> OrderDetailCollectionSnapshot

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> OrderDetailPaymentTableViewCellUIModel

}

struct OrderDetailUIModel: IOrderDetailUIModel {

    // MARK: Definitions
    var isActive: Bool
    private let orderModel: OrderModel

    // MARK: Initialize
    init(data: OrderDetailPassData) {
        self.orderModel = data.orderModel
        self.isActive = data.orderModel.isActive
    }

    var orderId: String {
        return orderModel.id ?? ""
    }

    var customerName: String {
        return orderModel.jbCustomerName
    }

    var customerId: String {
        return orderModel.jbCustomerId ?? ""
    }

    // MARK: Computed Props

    var collections: [OrderCollectionModel] = []
    var payments: [OrderPaymentModel] = []

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    mutating func setActive(isActive: Bool) {
        self.isActive = isActive
    }

    func oldDoubt() -> String {
        let _collections = self.collections.filter({ true == $0.isCalc })
        var totalPrice: Double = 0.0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        return "Toplam: \(totalPrice.decimalString()) TL"
    }

    func nowDoubt() -> String {
        let payments = self.payments.map({ $0.payment }).reduce(0, +)
        let _collections = self.collections.filter({ true == $0.isCalc })
        var totalPrice: Double = 0.0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        let waitingPrice = totalPrice - Double(payments)

        return "\(payments.decimalString()) TL Tahsilat, \(waitingPrice.decimalString()) TL Bekliyor"
    }

    func getCollection(orderId: String?) -> OrderCollectionModel? {
        if let index = self.collections.firstIndex(where: { $0.id == orderId }) {
            return self.collections[index]
        } else {
            return nil
        }
    }
}

// MARK: Props
extension OrderDetailUIModel {
    mutating func setCollectionResponse(data: [OrderCollectionModel]) {
        self.collections = data
    }

    mutating func setPaymentResponse(data: [OrderPaymentModel]) {
        self.payments = data
    }

    // Calc aktifleştir
    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            self.collections[index].isCalc = isCalc
        }
    }

    private func getTotalPrice(data: OrderCollectionModel) -> Double {
        return Double(data.count) * data.price * (1.0 + Double(data.kdv) / 100)
    }
}

// MARK: Collection
extension OrderDetailUIModel {

    mutating func buildCollectionSnapshot() -> OrderDetailCollectionSnapshot {
        var snapshot = OrderDetailCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareCollectionSnapshotRowModel() -> [OrderDetailCollectionRowModel] {
        let rowModels: [OrderDetailCollectionRowModel] = collections.compactMap { responseModel in

            let orderModel = OrderModel(id: nil,
                                        userId: responseModel.userId,
                                        jbCustomerName: self.customerName,
                                        jbCustomerId: self.customerId,
                                        desc: responseModel.desc ?? "",
                                        isActive: self.isActive,
                                        date: responseModel.date ?? "")

            let price = self.getTotalPrice(data: responseModel).decimalString()

            return OrderDetailCollectionRowModel(
                uiModel: OrderDetailCollectionTableViewCellUIModel(orderModel: orderModel,
                                                                   orderCollectionModel: responseModel,
                                                                   orderId: self.orderId,
                                                                   collectionId: responseModel.id,
                                                                   isCalc: responseModel.isCalc,
                                                                   isActive: self.isActive,
                                                                   date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                                                                   count: "\(responseModel.count) x \(responseModel.price.decimalString()) = \(price) TL+KDV",
                                                                   orderName: "\(responseModel.stockName) - \(responseModel.subStockName)",
                                                                   isVisibleButtons: true)
            )
        }
        return rowModels
    }

}

// MARK: TableView Helper
extension OrderDetailUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.payments.count
    }

    func getCellUIModel(at index: Int) -> OrderDetailPaymentTableViewCellUIModel {
        return OrderDetailPaymentTableViewCellUIModel(payment: self.payments[index],
                                                      isActive: self.isActive)
    }
}
