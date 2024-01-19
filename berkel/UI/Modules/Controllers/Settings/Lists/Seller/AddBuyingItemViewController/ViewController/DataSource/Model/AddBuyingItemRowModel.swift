//
//  AddBuyingItemRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import Foundation

class AddBuyingItemRowModel: Hashable {
    let id: UUID
    var uiModel: IAddBuyingItemTableViewCellUIModel

    init(uiModel: IAddBuyingItemTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension AddBuyingItemRowModel {
    static func == (lhs: AddBuyingItemRowModel, rhs: AddBuyingItemRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension AddBuyingItemRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
