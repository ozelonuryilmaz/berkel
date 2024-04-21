//
//  JBJBCustomerListRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import Foundation

class JBCustomerListRowModel: Hashable {
    let id: UUID
    var uiModel: IJBCustomerListTableViewCellUIModel

    init(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension JBCustomerListRowModel {
    static func == (lhs: JBCustomerListRowModel, rhs: JBCustomerListRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension JBCustomerListRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
