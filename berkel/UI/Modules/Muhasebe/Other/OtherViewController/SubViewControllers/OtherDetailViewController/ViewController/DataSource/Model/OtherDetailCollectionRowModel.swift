//
//  OtherDetailCollectionRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import Foundation

class OtherDetailCollectionRowModel: Hashable {
    let id: UUID
    var uiModel: IOtherDetailCollectionTableViewCellUIModel

    init(uiModel: IOtherDetailCollectionTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension OtherDetailCollectionRowModel {
    static func == (lhs: OtherDetailCollectionRowModel, rhs: OtherDetailCollectionRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OtherDetailCollectionRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
