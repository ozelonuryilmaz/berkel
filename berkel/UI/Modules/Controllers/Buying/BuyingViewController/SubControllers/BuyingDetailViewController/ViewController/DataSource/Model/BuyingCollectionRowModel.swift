//
//  BuyingCollectionRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import Foundation

class BuyingCollectionRowModel: Hashable {
    let id: UUID
    var uiModel: IBuyingCollectionTableViewCellUIModel

    init(uiModel: IBuyingCollectionTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension BuyingCollectionRowModel {
    static func == (lhs: BuyingCollectionRowModel, rhs: BuyingCollectionRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension BuyingCollectionRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
