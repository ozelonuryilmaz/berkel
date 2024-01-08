//
//  SellerChartsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.12.2023.
//

import UIKit

protocol ISellerChartsUIModel {

    var season: String { get }
    var sellerResponse: [SellerModel] { get }
    var sellerCollectionResponse: [SellerCollectionModel] { get }

    init(data: SellerChartsPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setResponseList(_ response: [SellerModel])
    mutating func setCollectionResponse(_ response: [SellerCollectionModel])
    mutating func setPaymentResponse(_ response: [SellerPaymentModel])

    mutating func buildCollectionSnapshot() -> SellerDetailCollectionSnapshot
}

struct SellerChartsUIModel: ISellerChartsUIModel {

    // MARK: Definitions
    var sellerResponse: [SellerModel] = []
    var sellerCollectionResponse: [SellerCollectionModel] = []
    var sellerPaymentResponse: [SellerPaymentModel] = []

    // MARK: Initialize
    init(data: SellerChartsPassData) {

    }

    // MARK: Computed Props

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
}

// MARK: Logic
extension SellerChartsUIModel {

    mutating func setResponseList(_ response: [SellerModel]) {
        self.sellerResponse = response
    }

    mutating func setCollectionResponse(_ response: [SellerCollectionModel]) {
        self.sellerCollectionResponse.append(contentsOf: response)
    }

    mutating func setPaymentResponse(_ response: [SellerPaymentModel]) {
        self.sellerPaymentResponse.append(contentsOf: response)
    }
}

// MARK: Props
extension SellerChartsUIModel {

    func oldDoubt() -> String {
        let _collections = self.sellerCollectionResponse.filter({ true == $0.isCalc })
        //let totalKG = _collections.map({ $0.daraliKg - $0.dara }).reduce(0, +)
        var totalPrice: Int = 0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }

        return "Genel Toplam: \(totalPrice.decimalString()) TL"
    }

    func nowDoubt() -> String {
        let payments = self.sellerPaymentResponse.map({ $0.payment }).reduce(0, +)
        let _collections = self.sellerCollectionResponse.filter({ true == $0.isCalc })
        var totalPrice: Int = 0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        let waitingPrice = totalPrice - payments

        return "\(payments.decimalString()) TL Tahsilat, \(waitingPrice.decimalString()) TL Bekliyor"
    }

    private func getTotalPrice(data: SellerCollectionModel) -> Int {
        let result = Double(data.daraliKg - data.dara)
        let price = result * data.price
        let kdv = result > 0 ? (data.kdv > 0 ? price * (1 + (data.kdv / 100)) : price) : 0
        return Int(kdv)
    }
}

// MARK: Collection
extension SellerChartsUIModel {

    mutating func buildCollectionSnapshot() -> SellerDetailCollectionSnapshot {
        var snapshot = SellerDetailCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    // CollecitonModel içerisinde rastgele birden fazla müşteri siparişleri bulunuyor.
    // Aynı müşterilerin toplam siparişleri toplanıyor.
    private func prepareCollectionSnapshotRowModel() -> [SellerDetailCollectionRowModel] {
        let data = sellerCollectionResponse.filter({ true == $0.isCalc })
        let collections: [String: [SellerCollectionModel]] = Dictionary(grouping: data, by: { $0.customerId ?? "-1" })
        var rowModels: [SellerDetailCollectionRowModel] = []

        let keys = Array(collections.keys)
        for key in keys {
            var customerName: String = ""
            //var totalKg: Int = 0 // Farklı ürünlerin KG toplamı
            var totalPrice: Int = 0

            if let collection = collections[key] {
                customerName = collection.first?.customerName ?? ""
                for c in collection {
                    //totalKg += (c.daraliKg - c.dara)
                    totalPrice += self.getTotalPrice(data: c)
                }
            }

            let payments = self.sellerPaymentResponse.filter({ $0.customerId == key }).map({ $0.payment }).reduce(0, +)
            let waitingPrice = totalPrice - payments

            let chartTotalKg = "Toplam: \(totalPrice.decimalString()) TL"
            let chartTotalPrice = "\(payments.decimalString()) TL Tahsilat, \(waitingPrice.decimalString()) TL Bekliyor"

            let data = SellerDetailCollectionTableViewCellUIModel(sellerModel: nil,
                                                                  sellerCollectionModel: nil,
                                                                  sellerId: nil,
                                                                  collectionId: nil,
                                                                  isCalc: true,
                                                                  isActive: true,
                                                                  date: customerName,
                                                                  faturaNo: "",
                                                                  totalKg: "",
                                                                  totalPrice: "",
                                                                  isVisibleButtons: false,
                                                                  chartTotalKg: chartTotalKg,
                                                                  chartTotalPrice: chartTotalPrice)

            rowModels.append(SellerDetailCollectionRowModel(uiModel: data))
        }

        return rowModels
    }

}
