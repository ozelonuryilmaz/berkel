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

    func buildSnapshot() -> AddBuyingItemSnapshot
} 

struct AddBuyingItemUIModel: IAddBuyingItemUIModel {

	// MARK: Definitions

	// MARK: Initialize
    init(data: AddBuyingItemPassData) {

    }

    // MARK: Computed Props
    
    
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
        var rowModels: [AddBuyingItemRowModel] = []

        return rowModels
    }
}
