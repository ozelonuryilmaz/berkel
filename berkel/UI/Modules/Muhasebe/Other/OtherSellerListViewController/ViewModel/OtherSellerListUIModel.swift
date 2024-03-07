//
//  OtherSellerListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol IOtherSellerListUIModel {

    var limit: Int { get }
    var isHaveBuildData: Bool { get }
    var isCancellableCellTabbed: Bool { get }

    init(data: OtherSellerListPassData)

    mutating func setResponse(_ response: [OtherSellerModel])
    mutating func appendFirstItem(data: OtherSellerModel)
    mutating func buildSnapshot() -> OtherSellerListSnapshot
    func updateSnapshot(currentSnapshot: OtherSellerListSnapshot,
                        newDatas: [OtherSellerModel]) -> OtherSellerListSnapshot

    func getLastCursor() -> [String]?
}

struct OtherSellerListUIModel: IOtherSellerListUIModel {

    // MARK: Definitions
    let isCancellableCellTabbed: Bool
    var response: [OtherSellerModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false

    // MARK: Initialize
    init(data: OtherSellerListPassData) {
        self.isCancellableCellTabbed = data.isCancellableCellTabbed
    }

    // MARK: Computed Props
    mutating func setResponse(_ response: [OtherSellerModel]) {
        self.response.append(contentsOf: response)
    }

    mutating func appendFirstItem(data: OtherSellerModel) {
        if let firstIndex = self.response.firstIndex(where: { $0.id == data.id }) {
            self.response.remove(at: firstIndex)
        }
        self.response.insert(data, at: 0)
    }
}

// MARK: Props
extension OtherSellerListUIModel {

    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }

        return [self.response.last?.date ?? ""] // order date olmalı
    }
}

// MARK: DataSource
extension OtherSellerListUIModel {

    mutating func buildSnapshot() -> OtherSellerListSnapshot {
        self.isHaveBuildData = true
        var snapshot = OtherSellerListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [OtherSellerListRowModel] {
        let rowModels: [OtherSellerListRowModel] = response.compactMap { item in
            return OtherSellerListRowModel(uiModel: OtherSellerListTableViewCellUIModel(id: item.id,
                                                                                        categoryId: item.categoryId,
                                                                                        categoryName: item.categoryName,
                                                                                        name: item.name,
                                                                                        desc: item.description,
                                                                                        phoneNumber: item.phoneNumber))
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: OtherSellerListSnapshot,
                        newDatas: [OtherSellerModel]) -> OtherSellerListSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [OtherSellerListRowModel] = []

        configuredItems = newDatas.compactMap({ item in
            return OtherSellerListRowModel(uiModel: OtherSellerListTableViewCellUIModel(id: item.id,
                                                                                        categoryId: item.categoryId,
                                                                                        categoryName: item.categoryName,
                                                                                        name: item.name,
                                                                                        desc: item.description,
                                                                                        phoneNumber: item.phoneNumber))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}

