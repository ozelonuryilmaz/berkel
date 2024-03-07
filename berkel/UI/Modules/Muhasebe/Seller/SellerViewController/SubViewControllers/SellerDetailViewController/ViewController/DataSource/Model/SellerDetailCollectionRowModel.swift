//
//  SellerDetailCollectionRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import Foundation

class SellerDetailCollectionRowModel: Hashable {
    let id: UUID
    var uiModel: ISellerDetailCollectionTableViewCellUIModel

    init(uiModel: ISellerDetailCollectionTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension SellerDetailCollectionRowModel {
    static func == (lhs: SellerDetailCollectionRowModel, rhs: SellerDetailCollectionRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension SellerDetailCollectionRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
