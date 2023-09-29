//
//  BuyingRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 29.09.2023.
//

import Foundation

class BuyingRowModel: Hashable {
    let id: UUID
    var uiModel: IBuyingTableViewCellUIModel

    init(uiModel: IBuyingTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension BuyingRowModel {
    static func == (lhs: BuyingRowModel, rhs: BuyingRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension BuyingRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
