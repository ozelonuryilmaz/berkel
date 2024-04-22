//
//  JBCustomerListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerListUIModel {

    var season: String { get }
    var limit: Int { get }
    var isHaveBuildData: Bool { get }
    var isCancellableCellTabbed: Bool { get }

    init(data: JBCustomerListPassData)

    mutating func setResponse(_ response: [JBCustomerModel])
    mutating func appendFirstItem(data: JBCustomerModel)
    mutating func buildSnapshot() -> JBCustomerListSnapshot
    func updateSnapshot(currentSnapshot: JBCustomerListSnapshot,
                        newDatas: [JBCustomerModel]) -> JBCustomerListSnapshot

    func getLastCursor() -> [String]?
}

struct JBCustomerListUIModel: IJBCustomerListUIModel {

    // MARK: Definitions
    let isCancellableCellTabbed: Bool
    var response: [JBCustomerModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false

    // MARK: Initialize
    init(data: JBCustomerListPassData) {
        self.isCancellableCellTabbed = data.isCancellableCellTabbed
    }

    // MARK: Computed Props
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    mutating func setResponse(_ response: [JBCustomerModel]) {
        self.response.append(contentsOf: response)
    }

    mutating func appendFirstItem(data: JBCustomerModel) {
        if let firstIndex = self.response.firstIndex(where: { $0.id == data.id }) {
            self.response.remove(at: firstIndex)
        }
        self.response.insert(data, at: 0)
    }
}

// MARK: Props
extension JBCustomerListUIModel {
    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }

        return [self.response.last?.date ?? ""] // order date olmalı
    }
}

// MARK: DataSource
extension JBCustomerListUIModel {

    mutating func buildSnapshot() -> JBCustomerListSnapshot {
        self.isHaveBuildData = true
        var snapshot = JBCustomerListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [JBCustomerListRowModel] {
        let rowModels: [JBCustomerListRowModel] = response.compactMap { item in
            return JBCustomerListRowModel(uiModel: JBCustomerListTableViewCellUIModel(customerModel: item))
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: JBCustomerListSnapshot,
                        newDatas: [JBCustomerModel]) -> JBCustomerListSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [JBCustomerListRowModel] = []

        configuredItems = newDatas.compactMap({ item in
            return JBCustomerListRowModel(uiModel: JBCustomerListTableViewCellUIModel(customerModel: item))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}

