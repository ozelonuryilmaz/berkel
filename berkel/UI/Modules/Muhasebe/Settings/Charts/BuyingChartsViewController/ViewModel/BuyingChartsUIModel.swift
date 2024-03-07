//
//  BuyingChartsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.01.2024.
//

import UIKit

protocol IBuyingChartsUIModel {

    var season: String { get }
    var buyingResponse: [NewBuyingModel] { get }
    var buyingCollectionResponse: [BuyingCollectionModel] { get }

    init(data: BuyingChartsPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setResponseList(_ response: [NewBuyingModel])
    mutating func setCollectionResponse(_ response: [BuyingCollectionModel])
    mutating func setPaymentResponse(_ response: [NewBuyingPaymentModel])
    mutating func appendWarehouseInsideCollection(collectionId: String, warehouses: [WarehouseModel])

    mutating func buildCollectionSnapshot() -> BuyingCollectionSnapshot
}

struct BuyingChartsUIModel: IBuyingChartsUIModel {

    // MARK: Definitions
    var buyingResponse: [NewBuyingModel] = []
    var buyingCollectionResponse: [BuyingCollectionModel] = []
    var buyingPaymentResponse: [NewBuyingPaymentModel] = []

    // MARK: Initialize
    init(data: BuyingChartsPassData) { }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
}

// MARK: Props
extension BuyingChartsUIModel {

    func oldDoubt() -> String {
        return "Genel Toplam: \(self.totalPrice().decimalString()) TL"
    }

    func nowDoubt() -> String {
        let paidPrice = Double(buyingPaymentResponse.map({ $0.payment }).reduce(0, +))
        let remaining = self.totalPrice() - paidPrice
        return "\(paidPrice.decimalString()) TL Ödendi, \(remaining.decimalString()) TL Bekliyor"
    }
}

// MARK: Private Props
private extension BuyingChartsUIModel {

    func totalPrice() -> Double {
        let collections = buyingCollectionResponse.filter { f in f.isCalc }
        return getTotalPrice(collections: collections)
    }

    func getTotalPrice(collections: [BuyingCollectionModel]) -> Double {
        var total: Double = 0
        for c in collections {
            var warehouseTotalPrice: Double = 0
            var warehouseKgs: Double = 0

            for w in c.warehouses ?? [] {
                warehouseKgs = warehouseKgs + Double(w.wavehouseKg)
                warehouseTotalPrice = warehouseTotalPrice + (Double(w.wavehouseKg) * w.wavehousePrice)
            }

            let kg: Double = Double(c.kantarFisi) - Double(((Double(c.palet) * c.paletDari) + (Double(c.redCase) * c.redDari) + (Double(c.greenCase) * c.greenDari) + (Double(c.black22FoodCase) * c.black22FoodDari) + (Double(c.bigBlackCase) * c.bigBlackDari)))
            let totalKg: Double = Double(c.percentFire > 0 ? kg - (kg * c.percentFire / 100): kg)

            let totalPrice: Double = ((totalKg - warehouseKgs) * c.kgPrice) + warehouseTotalPrice

            total = total + totalPrice
        }
        return total
    }
}

// MARK: Logic
extension BuyingChartsUIModel {

    mutating func setResponseList(_ response: [NewBuyingModel]) {
        self.buyingResponse = response.filter({ $0.isActive })
    }

    mutating func setCollectionResponse(_ response: [BuyingCollectionModel]) {
        self.buyingCollectionResponse.append(contentsOf: response)
    }

    mutating func setPaymentResponse(_ response: [NewBuyingPaymentModel]) {
        self.buyingPaymentResponse.append(contentsOf: response)
    }

    mutating func appendWarehouseInsideCollection(collectionId: String, warehouses: [WarehouseModel]) {
        if let index = self.buyingCollectionResponse.firstIndex(where: { $0.id == collectionId }) {
            var tempData: [WarehouseModel] = self.buyingCollectionResponse[index].warehouses ?? []
            tempData.append(contentsOf: warehouses)
            self.buyingCollectionResponse[index].warehouses = tempData
        }
    }
}

// MARK: Collection
extension BuyingChartsUIModel {

    mutating func buildCollectionSnapshot() -> BuyingCollectionSnapshot {
        var snapshot = BuyingCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    // CollecitonModel içerisinde rastgele birden fazla müşteri siparişleri bulunuyor.
    // Aynı müşterilerin toplam siparişleri toplanıyor.
    private func prepareCollectionSnapshotRowModel() -> [BuyingCollectionRowModel] {
        let data = buyingCollectionResponse.filter({ true == $0.isCalc })
        let collections: [String: [BuyingCollectionModel]] = Dictionary(grouping: data, by: { $0.sellerId ?? "-1" })
        var rowModels: [BuyingCollectionRowModel] = []

        let keys = Array(collections.keys)
        for key in keys {
            var sellerName: String = ""
            var totalPrice: Double = 0

            if let collections = collections[key] {
                sellerName = collections.first?.sellerName ?? ""
                totalPrice = self.getTotalPrice(collections: collections)
            }

            let payments = Double(self.buyingPaymentResponse.filter({ $0.sellerId == key }).map({ $0.payment }).reduce(0, +))
            let waitingPrice = totalPrice - payments

            let chartTotal = "Toplam: \(totalPrice.decimalString()) TL"
            let chartPayment = "\(payments.decimalString()) TL Ödendi, \(waitingPrice.decimalString()) TL Bekliyor"

            let data = BuyingCollectionTableViewCellUIModel(buyingId: "",
                                                            collectionId: "",
                                                            isCalc: true,
                                                            isActive: true,
                                                            date: sellerName,
                                                            totalKg: chartTotal,
                                                            totalKgPrice: chartPayment,
                                                            warehouseKg: "",
                                                            warehouseKgPrice: "",
                                                            isCharts: true)

            rowModels.append(BuyingCollectionRowModel(uiModel: data))
        }

        return rowModels
    }

}
