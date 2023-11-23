//
//  SellerRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.11.2023.
//

import Foundation

class SellerRowModel: Hashable {
    let id: UUID
    var uiModel: ISellerTableViewCellUIModel

    init(uiModel: ISellerTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension SellerRowModel {
    static func == (lhs: SellerRowModel, rhs: SellerRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension SellerRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
