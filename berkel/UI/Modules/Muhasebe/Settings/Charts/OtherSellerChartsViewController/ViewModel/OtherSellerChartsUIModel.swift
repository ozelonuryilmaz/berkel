//
//  OtherSellerChartsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import UIKit

protocol IOtherSellerChartsUIModel {
    
    var season: String { get }
    var sellerResponse: [OtherModel] { get }

	 init(data: OtherSellerChartsPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setResponseList(_ response: [OtherModel])
    mutating func setCollectionResponse(_ response: [OtherCollectionModel])
    mutating func setPaymentResponse(_ response: [OtherPaymentModel])

    mutating func buildCollectionSnapshot() -> OtherDetailCollectionSnapshot
} 

struct OtherSellerChartsUIModel: IOtherSellerChartsUIModel {

	// MARK: Definitions
    var sellerResponse: [OtherModel] = []
    var sellerCollectionResponse: [OtherCollectionModel] = []
    var sellerPaymentResponse: [OtherPaymentModel] = []

	// MARK: Initialize
    init(data: OtherSellerChartsPassData) { }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
}

// MARK: Logic
extension OtherSellerChartsUIModel {

    mutating func setResponseList(_ response: [OtherModel]) {
        self.sellerResponse = response.filter({ $0.isActive })
    }

    mutating func setCollectionResponse(_ response: [OtherCollectionModel]) {
        self.sellerCollectionResponse.append(contentsOf: response)
    }

    mutating func setPaymentResponse(_ response: [OtherPaymentModel]) {
        self.sellerPaymentResponse.append(contentsOf: response)
    }
}

// MARK: Props
extension OtherSellerChartsUIModel {

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

    private func getTotalPrice(data: OtherCollectionModel) -> Int {
        return Int(data.price)
    }
}

// MARK: Collection
extension OtherSellerChartsUIModel {

    mutating func buildCollectionSnapshot() -> OtherDetailCollectionSnapshot {
        var snapshot = OtherDetailCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    // CollecitonModel içerisinde rastgele birden fazla müşteri siparişleri bulunuyor.
    // Aynı müşterilerin toplam siparişleri toplanıyor.
    private func prepareCollectionSnapshotRowModel() -> [OtherDetailCollectionRowModel] {
        let data = sellerCollectionResponse.filter({ true == $0.isCalc })
        let collections: [String: [OtherCollectionModel]] = Dictionary(grouping: data, by: { $0.otherSellerId ?? "-1" })
        var rowModels: [OtherDetailCollectionRowModel] = []

        let keys = Array(collections.keys)
        for key in keys {
            var otherSellerName: String = ""
            //var totalKg: Int = 0 // Farklı ürünlerin KG toplamı
            var totalPrice: Int = 0

            if let collection = collections[key] {
                otherSellerName = collection.first?.otherSellerName ?? ""
                for c in collection {
                    totalPrice += self.getTotalPrice(data: c)
                }
            }

            let payments = self.sellerPaymentResponse.filter({ $0.otherSellerId == key }).map({ $0.payment }).reduce(0, +)
            let waitingPrice = totalPrice - payments

            let chartTotalKg = "Toplam: \(totalPrice.decimalString()) TL"
            let chartTotalPrice = "\(payments.decimalString()) TL Ödendi, \(waitingPrice.decimalString()) TL Bekliyor"

            let data = OtherDetailCollectionTableViewCellUIModel(otherModel: nil,
                                                                 otherCollectionModel: nil,
                                                                 otherId: nil,
                                                                 collectionId: nil,
                                                                 isCalc: true,
                                                                 isActive: true,
                                                                 date: otherSellerName,
                                                                 price: chartTotalKg,
                                                                 desc: chartTotalPrice,
                                                                 isVisibleButtons: false)

            rowModels.append(OtherDetailCollectionRowModel(uiModel: data))
        }

        return rowModels
    }

}
