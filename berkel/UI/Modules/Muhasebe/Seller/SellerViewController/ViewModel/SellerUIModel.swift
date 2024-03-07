//
//  SellerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol ISellerUIModel {
    
    var limit: Int { get }
    var season: String { get }
    var isHaveBuildData: Bool { get }

    init()
    
    func getLastCursor() -> [String]?
    mutating func setResponse(_ response: [SellerModel])
    mutating func appendFirstItem(data: SellerModel)

    mutating func updateIsActive(sellerId: String?, isActive: Bool)

    // DataSource
    mutating func buildSnapshot() -> SellerSnapshot
    func updateSnapshot(currentSnapshot: SellerSnapshot,
                        newDatas: [SellerModel]) -> SellerSnapshot

}

struct SellerUIModel: ISellerUIModel {

    // MARK: Definitions
    var response: [SellerModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false

    // MARK: Initialize
    init() { }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    // MARK: Computed Props
    
    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }
        return [self.response.last?.date ?? ""] // order date olmalı
    }

    mutating func setResponse(_ response: [SellerModel]) {
        self.response.append(contentsOf: response)
    }
}

// MARK: Props
extension SellerUIModel {

    mutating func appendFirstItem(data: SellerModel) {
        self.response.insert(data, at: 0)
    }

    mutating func updateIsActive(sellerId: String?, isActive: Bool) {
        if let index = self.response.firstIndex(where: { $0.id == sellerId }) {
            self.response[index].isActive = isActive
        }
    }
}

// MARK: DataSource
extension SellerUIModel {

    mutating func buildSnapshot() -> SellerSnapshot {
        self.isHaveBuildData = true
        var snapshot = SellerSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [SellerRowModel] {
        let rowModels: [SellerRowModel] = response.compactMap { sellerModel in

            return SellerRowModel(
                uiModel: SellerTableViewCellUIModel(sellerModel: sellerModel)
            )
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: SellerSnapshot,
                        newDatas: [SellerModel]) -> SellerSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [SellerRowModel] = []

        configuredItems = newDatas.compactMap({ sellerModel in

            return SellerRowModel(uiModel: SellerTableViewCellUIModel(sellerModel: sellerModel))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}
