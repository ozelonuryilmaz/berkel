//
//  OrderRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.04.2024.
//

import Foundation

class OrderRowModel: Hashable {
    let id: UUID
    var uiModel: IOrderTableViewCellUIModel

    init(uiModel: IOrderTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension OrderRowModel {
    static func == (lhs: OrderRowModel, rhs: OrderRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OrderRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
