//
//  StockDetailInfoRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//

import Foundation

class StockDetailInfoRowModel: Hashable {
    let id: UUID
    var uiModel: IStockDetailInfoTableViewCellUIModel

    init(uiModel: IStockDetailInfoTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension StockDetailInfoRowModel {
    static func == (lhs: StockDetailInfoRowModel, rhs: StockDetailInfoRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension StockDetailInfoRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
