//
//  SellerDetailUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

protocol ISellerDetailUIModel {
    
    var season: String { get }

    var sellerId: String { get }
    var customerName: String { get }
    var customerId: String { get }
    var isActive: Bool { get }

    var collections: [SellerCollectionModel] { get }

	 init(data: SellerDetailPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setActive(isActive: Bool)

    mutating func setCollectionResponse(data: [SellerCollectionModel])
    mutating func setPaymentResponse(data: [SellerPaymentModel])

    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool)

    func getCollection(sellerId: String?) -> SellerCollectionModel?

    // Collection
    mutating func buildCollectionSnapshot() -> SellerDetailCollectionSnapshot

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> SellerDetailPaymentTableViewCellUIModel
} 

struct SellerDetailUIModel: ISellerDetailUIModel {

	// MARK: Definitions
    let sellerId: String
    let customerName: String
    let customerId: String
    var isActive: Bool
    
    let productName: String
    let productId: String

	// MARK: Initialize
    init(data: SellerDetailPassData) {
        self.sellerId = data.sellerId
        self.customerName = data.customerName
        self.customerId = data.customerId
        self.isActive = data.isActive
        self.productName = data.productName
        self.productId = data.productId
    }

    // MARK: Computed Props
    
    var collections: [SellerCollectionModel] = []
    var payments: [SellerPaymentModel] = []

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    mutating func setActive(isActive: Bool) {
        self.isActive = isActive
    }
    
    func oldDoubt() -> String {
        return "-1"
    }

    func nowDoubt() -> String {
        return "-2"
    }

    func getCollection(sellerId: String?) -> SellerCollectionModel? {
        if let index = self.collections.firstIndex(where: { $0.id == sellerId }) {
            return self.collections[index]
        } else {
            return nil
        }
    }
}

// MARK: Props
extension SellerDetailUIModel {

    mutating func setCollectionResponse(data: [SellerCollectionModel]) {
        self.collections = data
    }

    mutating func setPaymentResponse(data: [SellerPaymentModel]) {
        self.payments = data
    }

    // Calc aktifleştir
    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            self.collections[index].isCalc = isCalc
        }
    }
    
    private func getTotalPrice(data: SellerCollectionModel) -> Int {
        return -1
    }
}


// MARK: Collection
extension SellerDetailUIModel {

    mutating func buildCollectionSnapshot() -> SellerDetailCollectionSnapshot {
        var snapshot = SellerDetailCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareCollectionSnapshotRowModel() -> [SellerDetailCollectionRowModel] {
        let rowModels: [SellerDetailCollectionRowModel] = collections.compactMap { responseModel in

            let sellerModel = SellerModel(userId: responseModel.userId,
                                          customerId: self.customerId,
                                          customerName: self.customerName,
                                          productId: self.productId,
                                          productName: self.productName,
                                          isActive: self.isActive,
                                          date: responseModel.date ?? "",
                                          kdv: responseModel.kdv,
                                          kgPrice: responseModel.price,
                                          desc: responseModel.desc)

            return SellerDetailCollectionRowModel(uiModel:
                SellerDetailCollectionTableViewCellUIModel(sellerModel: sellerModel,
                                                           sellerId: self.sellerId,
                                                           collectionId: responseModel.id,
                                                           isCalc: responseModel.isCalc,
                                                           isActive: self.isActive,
                                                           date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                                                           faturaNo: responseModel.faturaNo,
                                                           totalPrice: self.getTotalPrice(data: responseModel).decimalString())
            )
        }
        return rowModels
    }

}

// MARK: TableView Helper
extension SellerDetailUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.payments.count
    }

    func getCellUIModel(at index: Int) -> SellerDetailPaymentTableViewCellUIModel {
        return SellerDetailPaymentTableViewCellUIModel(payment: self.payments[index])
    }
}
