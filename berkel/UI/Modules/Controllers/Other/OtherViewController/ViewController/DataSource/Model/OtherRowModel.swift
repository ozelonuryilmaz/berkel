//
//  OtherRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import Foundation

class OtherRowModel: Hashable {
    let id: UUID
    var uiModel: IOtherTableViewCellUIModel

    init(uiModel: IOtherTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension OtherRowModel {
    static func == (lhs: OtherRowModel, rhs: OtherRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OtherRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
