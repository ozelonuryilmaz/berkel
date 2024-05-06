//
//  OrderDetailCollectionRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import Foundation

class OrderDetailCollectionRowModel: Hashable {
    let id: UUID
    var uiModel: IOrderDetailCollectionTableViewCellUIModel

    init(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension OrderDetailCollectionRowModel {
    static func == (lhs: OrderDetailCollectionRowModel, rhs: OrderDetailCollectionRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OrderDetailCollectionRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
