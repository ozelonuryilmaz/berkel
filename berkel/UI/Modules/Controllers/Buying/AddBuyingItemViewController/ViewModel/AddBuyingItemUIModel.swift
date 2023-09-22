//
//  AddBuyingItemUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IAddBuyingItemUIModel {

    init(data: AddBuyingItemPassData)

    mutating func setResponse(_ response: [AddBuyingItemResponseModel])
    func buildSnapshot() -> AddBuyingItemSnapshot
}

struct AddBuyingItemUIModel: IAddBuyingItemUIModel {

    // MARK: Definitions
    var response: [AddBuyingItemResponseModel] = []

    // MARK: Initialize
    init(data: AddBuyingItemPassData) {

    }

    // MARK: Computed Props
    mutating func setResponse(_ response: [AddBuyingItemResponseModel]) {
        self.response = response
    }

}

// MARK: DataSource
extension AddBuyingItemUIModel {

    func buildSnapshot() -> AddBuyingItemSnapshot {
        var snapshot = AddBuyingItemSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [AddBuyingItemRowModel] {
        let rowModels: [AddBuyingItemRowModel] = response.compactMap { responseModel in
            return AddBuyingItemRowModel(uiModel: AddBuyingItemTableViewCellUIModel(
                name: responseModel.name,
                tc: responseModel.tckn,
                desc: responseModel.description ?? "",
                phoneNumber: responseModel.phoneNumber)
            )
        }
        return rowModels
    }
}
