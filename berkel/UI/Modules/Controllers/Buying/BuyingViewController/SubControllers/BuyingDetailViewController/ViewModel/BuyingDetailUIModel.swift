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
    var isActive: Bool { get }

    var collections: [BuyingCollectionModel] { get }

    init(data: BuyingDetailPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String
    
    mutating func setActive(isActive: Bool)

    mutating func setCollectionResponse(data: [BuyingCollectionModel])
    mutating func setPaymentResponse(data: [NewBuyingPaymentModel])
    mutating func appendWarehouseInsideCollection(collectionId: String, warehouses: [WarehouseModel])

    func getWarehouses(collectionId: String?) -> [WarehouseModel]
    func getMaxWarehousesKg(collectionId: String?) -> Int
    mutating func appendWarehousesIntoCollection(collectionId: String?, warehouse: WarehouseModel)
    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool)
    
    func getCollection(collectionId: String?) -> BuyingCollectionModel?

    // Collection
    mutating func buildCollectionSnapshot() -> BuyingCollectionSnapshot

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> BuyingPaymentTableViewCellUIModel
}

struct BuyingDetailUIModel: IBuyingDetailUIModel {

    // MARK: Definitions
    let buyingId: String
    let sellerName: String
    let productName: String
    var isActive: Bool

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

    mutating func setActive(isActive: Bool) {
        self.isActive = isActive
    }
    
    // MARK: Computed Props

    func oldDoubt() -> String {
        return "Toplam: \(self.totalKg().decimalString()) Kg, \(self.totalPrice().decimalString()) TL"
    }

    func nowDoubt() -> String {
        return "\(paidPrice().decimalString()) TL Ödendi, \(remaining().decimalString()) TL Bekliyor"
    }

    func paidPrice() -> Double {
        let price = payments.map({ $0.payment }).reduce(0, +)
        return Double(price)
    }

    func remaining() -> Double {
        return self.totalPrice() - paidPrice()
    }

    func totalKg() -> Double {
        var total: Double = 0
        collections.filter { f in f.isCalc }.forEach { c in
            let kg: Double = Double(c.kantarFisi) - Double(((Double(c.palet) * c.paletDari) + (Double(c.redCase) * c.redDari) + (Double(c.greenCase) * c.greenDari) + (Double(c.black22FoodCase) * c.black22FoodDari) + (Double(c.bigBlackCase) * c.bigBlackDari)))

            total = total + (c.percentFire > 0 ? kg - (kg * c.percentFire / 100): kg)
        }
        return total
    }

    func totalPrice() -> Double {
        var total: Double = 0
        let collections = collections.filter { f in f.isCalc }
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
    
    func getCollection(collectionId: String?) -> BuyingCollectionModel? {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            return self.collections[index]
        } else {
            return nil
        }
    }
}

// MARK: Props
extension BuyingDetailUIModel {

    mutating func setCollectionResponse(data: [BuyingCollectionModel]) {
        self.collections = data
    }

    mutating func appendWarehouseInsideCollection(collectionId: String, warehouses: [WarehouseModel]) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            var tempData: [WarehouseModel] = self.collections[index].warehouses ?? []
            tempData.append(contentsOf: warehouses)
            self.collections[index].warehouses = tempData
        }
    }

    mutating func setPaymentResponse(data: [NewBuyingPaymentModel]) {
        self.payments = data
    }

    func getWarehouses(collectionId: String?) -> [WarehouseModel] {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            return self.collections[index].warehouses ?? []
        } else {
            return []
        }
    }

    func getCollectionKg(collectionId: String?) -> Double {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            let c = self.collections[index]
            let kg: Double = Double(c.kantarFisi) - Double(((Double(c.palet) * c.paletDari) + (Double(c.redCase) * c.redDari) + (Double(c.greenCase) * c.greenDari) + (Double(c.black22FoodCase) * c.black22FoodDari) + (Double(c.bigBlackCase) * c.bigBlackDari)))
            return (c.percentFire > 0 ? kg - (kg * c.percentFire / 100): kg)
        } else {
            return 0
        }
    }

    // Yeni Depo çıktısı kalan Toplam Kg'den büyük girilmemeli
    func getMaxWarehousesKg(collectionId: String?) -> Int {
        let warehousesKg: Int = self.getWarehouses(collectionId: collectionId)
            .compactMap { $0.wavehouseKg }
            .reduce(0, +)
        let collectionKg = self.getCollectionKg(collectionId: collectionId)
        return Int(collectionKg) - warehousesKg
    }

    // Depo çıktısı eklendiğinde collection güncelleniyor
    mutating func appendWarehousesIntoCollection(collectionId: String?, warehouse: WarehouseModel) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            var tempData: [WarehouseModel] = self.collections[index].warehouses ?? []
            tempData.insert(warehouse, at: 0)
            self.collections[index].warehouses = tempData
        }
    }

    // Calc aktifleştir
    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            self.collections[index].isCalc = isCalc
        }
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

            var warehouseTotalPrice: Double = 0
            var warehouseKgs: Double = 0
            responseModel.warehouses?.forEach({ w in
                warehouseKgs = warehouseKgs + Double(w.wavehouseKg)
                warehouseTotalPrice = warehouseTotalPrice + (Double(w.wavehouseKg) * w.wavehousePrice)
            })

            let kg: Double = Double(responseModel.kantarFisi) - Double(((Double(responseModel.palet) * responseModel.paletDari) + (Double(responseModel.redCase) * responseModel.redDari) + (Double(responseModel.greenCase) * responseModel.greenDari) + (Double(responseModel.black22FoodCase) * responseModel.black22FoodDari) + (Double(responseModel.bigBlackCase) * responseModel.bigBlackDari)))
            let totalKg: Double = Double(responseModel.percentFire > 0 ? kg - (kg * responseModel.percentFire / 100): kg)

            let totalPrice: Double = ((totalKg - warehouseKgs) * responseModel.kgPrice) + warehouseTotalPrice

            return BuyingCollectionRowModel(uiModel: BuyingCollectionTableViewCellUIModel(
                buyingId: self.buyingId,
                collectionId: responseModel.id,
                isCalc: responseModel.isCalc,
                isActive: self.isActive,
                date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                totalKg: totalKg.decimalString(),
                totalKgPrice: totalPrice.decimalString(),
                warehouseKg: warehouseKgs.decimalString(),
                warehouseKgPrice: warehouseTotalPrice.decimalString())
            )
        }
        return rowModels
    }

}


// MARK: TableView Helper
extension BuyingDetailUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.payments.count
    }

    func getCellUIModel(at index: Int) -> BuyingPaymentTableViewCellUIModel {
        return BuyingPaymentTableViewCellUIModel(payment: self.payments[index])
    }
}
