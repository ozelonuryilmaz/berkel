//
//  BuyingUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingUIModel {

    var limit: Int { get }
    var season: String { get }
    var isHaveBuildData: Bool { get }

    init()

    func getLastCursor() -> [String]?
    mutating func setResponse(_ response: [NewBuyingModel])
    mutating func appendFirstItem(data: NewBuyingModel)

    // DataSource
    mutating func buildSnapshot() -> BuyingSnapshot
    func updateSnapshot(currentSnapshot: BuyingSnapshot,
                        newDatas: [NewBuyingModel]) -> BuyingSnapshot
}

struct BuyingUIModel: IBuyingUIModel {

    // MARK: Definitions
    var response: [NewBuyingModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false

    // MARK: Initialize
    init() { }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }
        return [self.response.last?.date ?? ""] // order date olmalı
    }

    mutating func setResponse(_ response: [NewBuyingModel]) {
        self.response.append(contentsOf: response)
    }

    // MARK: Computed Props
}

// MARK: Props
extension BuyingUIModel {

    mutating func appendFirstItem(data: NewBuyingModel) {
        self.response.insert(data, at: 0)
    }
}


// MARK: DataSource
extension BuyingUIModel {

    mutating func buildSnapshot() -> BuyingSnapshot {
        self.isHaveBuildData = true
        var snapshot = BuyingSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [BuyingRowModel] {
        let rowModels: [BuyingRowModel] = response.compactMap { responseModel in

            return BuyingRowModel(
                uiModel: BuyingTableViewCellUIModel(id: responseModel.id ?? "",
                                                    isActive: responseModel.isActive,
                                                    sellerName: responseModel.sellerName,
                                                    productName: responseModel.productName,
                                                    kg: responseModel.productKGPrice,
                                                    price: "- TL")
            )
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: BuyingSnapshot,
                        newDatas: [NewBuyingModel]) -> BuyingSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [BuyingRowModel] = []

        configuredItems = newDatas.compactMap({ item in

            return BuyingRowModel(uiModel: BuyingTableViewCellUIModel(id: item.id ?? "",
                                                                      isActive: item.isActive,
                                                                      sellerName: item.sellerName,
                                                                      productName: item.productName,
                                                                      kg: item.productKGPrice,
                                                                      price: "- TL"))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}
