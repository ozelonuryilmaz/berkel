//
//  CavusListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

protocol ICavusListUIModel {

    var limit: Int { get }
    var isHaveBuildData: Bool { get }
    var isCancellableCellTabbed: Bool { get }

    init(data: CavusListPassData)

    mutating func setResponse(_ response: [CavusModel])
    mutating func appendFirstItem(data: CavusModel)
    mutating func buildSnapshot() -> CavusListSnapshot
    func updateSnapshot(currentSnapshot: CavusListSnapshot,
                        newDatas: [CavusModel]) -> CavusListSnapshot

    func getLastCursor() -> [String]?
}

struct CavusListUIModel: ICavusListUIModel {

    // MARK: Definitions
    var response: [CavusModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false
    let isCancellableCellTabbed: Bool

    // MARK: Initialize
    init(data: CavusListPassData) {
        self.isCancellableCellTabbed = data.isCancellableCellTabbed
    }

    // MARK: Computed Props
    mutating func setResponse(_ response: [CavusModel]) {
        self.response.append(contentsOf: response)
    }

    mutating func appendFirstItem(data: CavusModel) {
        self.response.insert(data, at: 0)
    }
}

// MARK: Pagination
extension CavusListUIModel {

    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }

        return [self.response.last?.date ?? ""] // order date olmalı
    }
}

// MARK: DataSource
extension CavusListUIModel {

    mutating func buildSnapshot() -> CavusListSnapshot {
        self.isHaveBuildData = true
        var snapshot = CavusListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [CavusListRowModel] {
        let rowModels: [CavusListRowModel] = response.compactMap { item in
            return CavusListRowModel(uiModel: CavusListTableViewCellUIModel(id: item.id,
                                                                            name: item.name,
                                                                            desc: item.description,
                                                                            phoneNumber: item.phoneNumber))
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: CavusListSnapshot,
                        newDatas: [CavusModel]) -> CavusListSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [CavusListRowModel] = []

        configuredItems = newDatas.compactMap({ item in
            return CavusListRowModel(uiModel: CavusListTableViewCellUIModel(id: item.id,
                                                                            name: item.name,
                                                                            desc: item.description,
                                                                            phoneNumber: item.phoneNumber))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}
