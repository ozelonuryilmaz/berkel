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
    var userId: String { get }

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
    mutating func updateFaturaNo(collectionId: String, faturaNo: String)
    mutating func updateFaturaNo(paymentId: String, faturaNo: String)
    mutating func deleteCollection(collectionId: String)

    func getCollection(orderId: String?) -> OrderCollectionModel?
    func getInvoicePDFModel() -> [InvoicePDFModel]

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

    var userId: String {
        return UserManager.shared.userId ?? ""
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

    mutating func updateFaturaNo(collectionId: String, faturaNo: String) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            self.collections[index].faturaNo = faturaNo
        }
    }

    mutating func updateFaturaNo(paymentId: String, faturaNo: String) {
        if let index = self.payments.firstIndex(where: { $0.id == paymentId }) {
            self.payments[index].faturaNo = faturaNo
        }
    }

    mutating func deleteCollection(collectionId: String) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            self.collections.remove(at: index)
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
                                                                   count: "\(responseModel.count) x \(responseModel.price.decimalString()) + KDV = \(price) TL",
                                                                   orderName: "\(responseModel.stockName) - \(responseModel.subStockName)")
            )
        }
        return rowModels
    }

}

// MARK: Gelir Gider Çizelgesi
extension OrderDetailUIModel {

    func getInvoicePDFModel() -> [InvoicePDFModel] {
        return combineOrders(collections: collections, payments: payments)
    }

    func combineOrders(collections: [OrderCollectionModel], payments: [OrderPaymentModel]) -> [InvoicePDFModel] {
        var invoices: [InvoicePDFModel] = collections.compactMap({

            guard let faturaNo = $0.faturaNo else { return nil }
            return InvoicePDFModel(date: $0.date ?? "", description: "*\(faturaNo) no'lu fatura", invoiceNo: faturaNo,
                                   type: .collection, isSumBalance: false, debit: getTotalPrice(data: $0), credit: 0, balance: getTotalPrice(data: $0))
        }).reduce(into: [:]) { (acc: inout [String: InvoicePDFModel], cur: InvoicePDFModel) in

            let key = cur.invoiceNo
            if let existing = acc[key] {
                acc[key]?.debit += cur.debit
                acc[key]?.balance += cur.balance
            } else {
                acc[key] = cur
            }
        }.values.sorted(by: { $0.date < $1.date })

        let paymentInvoices: [InvoicePDFModel] = payments.compactMap({
            guard let faturaNo = $0.faturaNo else { return nil }
            return InvoicePDFModel(date: $0.date ?? "", description: "\(faturaNo) no'lu fatura tahsilatı", invoiceNo: faturaNo,
                                   type: .payment, isSumBalance: false, debit: 0, credit: Double($0.payment), balance: 0)
        }).sorted(by: { $0.date > $1.date })

        // PaymentInvoices'i invoices dizisine ekleyin
        for payment in paymentInvoices {
            if let index = invoices.firstIndex(where: { $0.invoiceNo == payment.invoiceNo }) {

                let newPayment = InvoicePDFModel(date: payment.date,
                                                 description: payment.description,
                                                 invoiceNo: payment.invoiceNo,
                                                 type: payment.type,
                                                 isSumBalance: false,
                                                 debit: 0,
                                                 credit: payment.credit,
                                                 balance: 0)

                invoices.insert(newPayment, at: index + 1)
            }
        }

        for i in 0..<invoices.count {
            // Eğer mevcut elemanın tipi payment ise ve bir önceki elemanla aynı fatura numarasına sahipse
            if invoices[i].type == .payment,
                i > 0,
                invoices[i].invoiceNo == invoices[i - 1].invoiceNo {
                // Önceki balance'dan mevcut credit'i çıkararak yeni balance hesapla
                invoices[i].balance = invoices[i - 1].balance - invoices[i].credit
            }
        }

        // Fatura numarasına göre gruplama ve her grup için en son kaydı bulma
        let groupedInvoices = Dictionary(grouping: invoices) { $0.invoiceNo }
        var idx: [String] = []
        for (_, values) in groupedInvoices {
            idx.append(values.last?.uuid ?? "")
        }

        // Her grup için en son tarihli kaydı işaretleme
        invoices = invoices.map { invoice in
            var modifiedInvoice = invoice
            modifiedInvoice.isSumBalance = idx.contains(invoice.uuid)
            return modifiedInvoice
        }

        return invoices
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

/*
 
 
 for (p_index, payment) in paymentInvoices.enumerated() {
     for (index, collection) in invoices.enumerated() {
         if collection.invoiceNo == payment.invoiceNo {
             let newPayment = InvoicePDFModel(date: payment.date,
                                              description: payment.description,
                                              invoiceNo: payment.invoiceNo,
                                              type: payment.type,
                                              isSumBalance: false,
                                              debit: 0,
                                              credit: payment.credit,
                                              balance: 0)
             
             invoices.insert(newPayment, at: index + 1)
         }
     }
 }

 */
