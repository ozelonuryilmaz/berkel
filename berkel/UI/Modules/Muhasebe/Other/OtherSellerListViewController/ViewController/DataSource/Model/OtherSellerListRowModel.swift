//
//  OtherSellerListRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import Foundation

class OtherSellerListRowModel: Hashable {
    let id: UUID
    var uiModel: IOtherSellerListTableViewCellUIModel

    init(uiModel: IOtherSellerListTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension OtherSellerListRowModel {
    static func == (lhs: OtherSellerListRowModel, rhs: OtherSellerListRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OtherSellerListRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
