//
//  AddBuyingItemUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//
//

import UIKit

protocol IAddBuyingItemUIModel {

    var limit: Int { get }
    var isHaveBuildData: Bool { get }
    var isCancellableCellTabbed: Bool { get }

    init(data: AddBuyingItemPassData)

    mutating func setResponse(_ response: [AddBuyingItemResponseModel])
    mutating func appendFirstItem(data: AddSellerModel) -> [AddBuyingItemResponseModel]
    mutating func buildSnapshot() -> AddBuyingItemSnapshot
    func updateSnapshot(currentSnapshot: AddBuyingItemSnapshot,
                        newDatas: [AddBuyingItemResponseModel]) -> AddBuyingItemSnapshot

    func getLastCursor() -> [String]?
}

struct AddBuyingItemUIModel: IAddBuyingItemUIModel {

    // MARK: Definitions
    var response: [AddBuyingItemResponseModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false
    let isCancellableCellTabbed: Bool

    // MARK: Initialize
    init(data: AddBuyingItemPassData) {
        self.isCancellableCellTabbed = data.isCancellableCellTabbed
    }

    // MARK: Computed Props
    mutating func setResponse(_ response: [AddBuyingItemResponseModel]) {
        self.response.append(contentsOf: response)
    }

    mutating func appendFirstItem(data: AddSellerModel) -> [AddBuyingItemResponseModel] {
        if let firstIndex = self.response.firstIndex(where: { $0.id == data.id }) {
            self.response.remove(at: firstIndex)
        }

        let addBuyingItem = AddBuyingItemResponseModel(id: data.id ?? "", name: data.name ?? "", tckn: data.tckn ?? "", phoneNumber: data.phoneNumber ?? "", description: data.description ?? "", date: data.date ?? "")
        self.response.insert(addBuyingItem, at: 0)

        return [addBuyingItem]
    }
}

// MARK: Pagination
extension AddBuyingItemUIModel {

    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }

        return [self.response.last?.date ?? ""] // order date olmalı
    }
}

// MARK: DataSource
extension AddBuyingItemUIModel {

    mutating func buildSnapshot() -> AddBuyingItemSnapshot {
        self.isHaveBuildData = true
        var snapshot = AddBuyingItemSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [AddBuyingItemRowModel] {
        let rowModels: [AddBuyingItemRowModel] = response.compactMap { responseModel in
            return AddBuyingItemRowModel(uiModel: AddBuyingItemTableViewCellUIModel(
                id: responseModel.id,
                name: responseModel.name,
                tc: responseModel.tckn,
                desc: responseModel.description ?? "",
                date: responseModel.date,
                phoneNumber: responseModel.phoneNumber)
            )
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: AddBuyingItemSnapshot,
                        newDatas: [AddBuyingItemResponseModel]) -> AddBuyingItemSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [AddBuyingItemRowModel] = []

        configuredItems = newDatas.compactMap({ item in
            return AddBuyingItemRowModel(uiModel: AddBuyingItemTableViewCellUIModel(id: item.id, name: item.name, tc: item.tckn, desc: item.description ?? "", date: item.date, phoneNumber: item.phoneNumber))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}
