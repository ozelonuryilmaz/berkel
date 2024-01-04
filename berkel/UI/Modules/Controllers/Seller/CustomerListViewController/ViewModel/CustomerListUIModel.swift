//
//  CustomerListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit

protocol ICustomerListUIModel {

    var limit: Int { get }
    var isHaveBuildData: Bool { get }
    var isCancellableCellTabbed: Bool { get }

    init(data: CustomerListPassData)

    mutating func setResponse(_ response: [CustomerModel])
    mutating func appendFirstItem(data: CustomerModel)
    mutating func buildSnapshot() -> CustomerListSnapshot
    func updateSnapshot(currentSnapshot: CustomerListSnapshot,
                        newDatas: [CustomerModel]) -> CustomerListSnapshot

    func getLastCursor() -> [String]?
}

struct CustomerListUIModel: ICustomerListUIModel {

    // MARK: Definitions
    let isCancellableCellTabbed: Bool
    var response: [CustomerModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false

    // MARK: Initialize
    init(data: CustomerListPassData) {
        self.isCancellableCellTabbed = data.isCancellableCellTabbed
    }

    // MARK: Computed Props
    mutating func setResponse(_ response: [CustomerModel]) {
        self.response.append(contentsOf: response)
    }

    mutating func appendFirstItem(data: CustomerModel) {
        self.response.insert(data, at: 0)
    }
}

// MARK: Props
extension CustomerListUIModel {

    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }

        return [self.response.last?.date ?? ""] // order date olmalı
    }
}

// MARK: DataSource
extension CustomerListUIModel {

    mutating func buildSnapshot() -> CustomerListSnapshot {
        self.isHaveBuildData = true
        var snapshot = CustomerListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [CustomerListRowModel] {
        let rowModels: [CustomerListRowModel] = response.compactMap { item in
            return CustomerListRowModel(uiModel: CustomerListTableViewCellUIModel(id: item.id,
                                                                                  name: item.name,
                                                                                  desc: item.description,
                                                                                  phoneNumber: item.phoneNumber))
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: CustomerListSnapshot,
                        newDatas: [CustomerModel]) -> CustomerListSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [CustomerListRowModel] = []

        configuredItems = newDatas.compactMap({ item in
            return CustomerListRowModel(uiModel: CustomerListTableViewCellUIModel(id: item.id,
                                                                                  name: item.name,
                                                                                  desc: item.description,
                                                                                  phoneNumber: item.phoneNumber))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}

