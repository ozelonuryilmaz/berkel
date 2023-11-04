//
//  CavusListRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import Foundation

class CavusListRowModel: Hashable {
    let id: UUID
    var uiModel: ICavusListTableViewCellUIModel

    init(uiModel: ICavusListTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension CavusListRowModel {
    static func == (lhs: CavusListRowModel, rhs: CavusListRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CavusListRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
