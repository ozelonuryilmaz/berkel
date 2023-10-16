//
//  BuyingDetailUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingDetailUIModel {

    var season: String { get }

    var buyingId: String { get }
    var sellerName: String { get }
    var productName: String { get }

    var oldDoubt: String { get }
    var nowDoubt: String { get }

    init(data: BuyingDetailPassData)

    mutating func setCollectionResponse(data: [BuyingCollectionModel])
    mutating func setPaymentResponse(data: [NewBuyingPaymentModel])

    // Collection
    mutating func buildCollectionSnapshot() -> BuyingCollectionSnapshot
    func updateCollectionSnapshot(currentSnapshot: BuyingCollectionSnapshot,
                                  newDatas: [BuyingCollectionModel]) -> BuyingCollectionSnapshot
}

struct BuyingDetailUIModel: IBuyingDetailUIModel {

    // MARK: Definitions
    let buyingId: String
    let sellerName: String
    let productName: String
    let isActive: Bool

    // MARK: Initialize
    init(data: BuyingDetailPassData) {
        self.buyingId = data.buyingId
        self.sellerName = data.sellerName
        self.productName = data.productName
        self.isActive = data.isActive
    }

    var collections: [BuyingCollectionModel] = []
    var payments: [NewBuyingPaymentModel] = []

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var oldDoubt: String {
        return "Toplam: \(totalKg.decimalString()) Kg, \(totalPrice.decimalString()) TL"
    }

    var nowDoubt: String {
        return "\(paidPrice.decimalString()) TL Ödendi, \(remaining.decimalString()) TL Kaldı"
    }

    var totalKg: Double {
        var total: Double = 0
        collections.filter { f in f.isCalc }.forEach { c in
            let kg: Double = Double(c.kantarFisi) - Double(((Double(c.palet) * c.paletDari) + (Double(c.redCase) * c.redDari) + (Double(c.greenCase) * c.greenDari) + (Double(c.black22FoodCase) * c.black22FoodDari) + (Double(c.bigBlackCase) * c.bigBlackDari)))

            total = total + (c.percentFire > 0 ? kg - (kg * c.percentFire / 100): kg)
        }
        return total
    }

    // TODO: Depo Çıkması fiyatını eklemeyi unutma !!!!

    var totalPrice: Double {
        var total: Double = 0
        collections.filter { f in f.isCalc }.forEach { c in
            let kg: Double = Double(c.kantarFisi) - Double(((Double(c.palet) * c.paletDari) + (Double(c.redCase) * c.redDari) + (Double(c.greenCase) * c.greenDari) + (Double(c.black22FoodCase) * c.black22FoodDari) + (Double(c.bigBlackCase) * c.bigBlackDari)))

            total = total + ((c.percentFire > 0 ? kg - (kg * c.percentFire / 100): kg) * c.kgPrice)
        }
        return total
    }

    var paidPrice: Double {
        let price = payments.map({ $0.payment }).reduce(0, +)
        return Double(price)
    }

    var remaining: Double {
        return totalPrice - paidPrice
    }

    // MARK: Computed Props

}

// MARK: Props
extension BuyingDetailUIModel {

    mutating func setCollectionResponse(data: [BuyingCollectionModel]) {
        self.collections = data
    }

    mutating func setPaymentResponse(data: [NewBuyingPaymentModel]) {
        self.payments = data
    }
}

// MARK: Collection
extension BuyingDetailUIModel {

    mutating func buildCollectionSnapshot() -> BuyingCollectionSnapshot {
        var snapshot = BuyingCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareCollectionSnapshotRowModel() -> [BuyingCollectionRowModel] {
        let rowModels: [BuyingCollectionRowModel] = collections.compactMap { responseModel in
            return BuyingCollectionRowModel(uiModel: BuyingCollectionTableViewCellUIModel(
                id: responseModel.id,
                isCalc: responseModel.isCalc,
                isActive: self.isActive,
                date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                totalKg: "--",
                warehouseKg: "--")
            )
        }
        return rowModels
    }

    func updateCollectionSnapshot(currentSnapshot: BuyingCollectionSnapshot,
                                  newDatas: [BuyingCollectionModel]) -> BuyingCollectionSnapshot {
        var snapshot = currentSnapshot
        var configuredItems: [BuyingCollectionRowModel] = []

        configuredItems = newDatas.compactMap({ responseModel in
            return BuyingCollectionRowModel(uiModel: BuyingCollectionTableViewCellUIModel(
                id: responseModel.id,
                isCalc: responseModel.isCalc,
                isActive: self.isActive,
                date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                totalKg: "--",
                warehouseKg: "--")
            )
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}

