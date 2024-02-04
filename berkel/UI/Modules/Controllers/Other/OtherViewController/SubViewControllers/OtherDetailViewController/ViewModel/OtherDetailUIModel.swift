//
//  OtherDetailUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit

protocol IOtherDetailUIModel {

    var season: String { get }

    var otherId: String { get }
    var otherSellerName: String { get }
    var otherSellerId: String { get }
    var isActive: Bool { get }
    var categoryName: String { get }

    var collections: [OtherCollectionModel] { get }

    init(data: OtherDetailPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setActive(isActive: Bool)

    mutating func setCollectionResponse(data: [OtherCollectionModel])
    mutating func setPaymentResponse(data: [OtherPaymentModel])

    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool)

    func getCollection(otherId: String?) -> OtherCollectionModel?

    // Collection
    mutating func buildCollectionSnapshot() -> OtherDetailCollectionSnapshot

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> OtherDetailPaymentTableViewCellUIModel

} 

struct OtherDetailUIModel: IOtherDetailUIModel {

    // MARK: Definitions
    let sellerId: String
    let otherSellerName: String
    let otherSellerId: String
    var isActive: Bool

    let categoryName: String
    let categoryId: String

    // MARK: Initialize
    init(data: OtherDetailPassData) {
        self.otherId = data.otherId
        self.otherSellerName = data.otherSellerName
        self.otherSellerId = data.otherSellerId
        self.isActive = data.isActive
        self.categoryName = data.categoryName
        self.categoryId = data.categoryId
    }

    // MARK: Computed Props

    var collections: [OtherCollectionModel] = []
    var payments: [OtherPaymentModel] = []

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    mutating func setActive(isActive: Bool) {
        self.isActive = isActive
    }
    
    // MARK: Computed Props
    
    func oldDoubt() -> String {
        let _collections = self.collections.filter({ true == $0.isCalc })
        var totalPrice: Int = 0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        return "Toplam: \(totalPrice.decimalString()) TL"
    }

    func nowDoubt() -> String {
        let payments = self.payments.map({ $0.payment }).reduce(0, +)
        let _collections = self.collections.filter({ true == $0.isCalc })
        var totalPrice: Int = 0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        let waitingPrice = totalPrice - payments

        return "\(payments.decimalString()) TL Tahsilat, \(waitingPrice.decimalString()) TL Bekliyor"
    }

    func getCollection(otherId: String?) -> OtherCollectionModel? {
        if let index = self.collections.firstIndex(where: { $0.id == sellerId }) {
            return self.collections[index]
        } else {
            return nil
        }
    }
}

// MARK: Props
extension OtherDetailUIModel {

    mutating func setCollectionResponse(data: [OtherCollectionModel]) {
        self.collections = data
    }

    mutating func setPaymentResponse(data: [OtherPaymentModel]) {
        self.payments = data
    }

    // Calc aktifleştir
    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            self.collections[index].isCalc = isCalc
        }
    }

    private func getTotalPrice(data: OtherCollectionModel) -> Int {
        return Int(data.price)
    }
}

// MARK: Collection
extension OtherDetailUIModel {

    mutating func buildCollectionSnapshot() -> OtherDetailCollectionSnapshot {
        var snapshot = OtherDetailCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareCollectionSnapshotRowModel() -> [OtherDetailCollectionRowModel] {
        let rowModels: [OtherDetailCollectionRowModel] = collections.compactMap { responseModel in

            let otherModel = OtherModel(userId: responseModel.userId,
                                        otherSellerId: self.otherSellerId,
                                        otherSellerName: self.otherSellerName,
                                        otherSellerCategoryId: self.categoryId,
                                        otherSellerCategoryName: self.categoryName,
                                        isActive: self.isActive,
                                         date: responseModel.date ?? "",
                                         desc: responseModel.desc)

            return OtherDetailCollectionRowModel(uiModel:
                OtherDetailCollectionTableViewCellUIModel(sellerModel: sellerModel,
                                                           sellerCollectionModel: responseModel,
                                                           sellerId: self.sellerId,
                                                           collectionId: responseModel.id,
                                                           isCalc: responseModel.isCalc,
                                                           isActive: self.isActive,
                                                           date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                                                           faturaNo: responseModel.faturaNo,
                                                           totalKg: (responseModel.daraliKg - responseModel.dara).decimalString(),
                                                           totalPrice: self.getTotalPrice(data: responseModel).decimalString(),
                                                           isVisibleButtons: true,
                                                           chartTotalKg: nil,
                                                           chartTotalPrice: nil)
            )
        }
        return rowModels
    }

}

// MARK: TableView Helper
extension OtherDetailUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.payments.count
    }

    func getCellUIModel(at index: Int) -> OtherDetailPaymentTableViewCellUIModel {
        return OtherDetailPaymentTableViewCellUIModel(payment: self.payments[index])
    }
}
