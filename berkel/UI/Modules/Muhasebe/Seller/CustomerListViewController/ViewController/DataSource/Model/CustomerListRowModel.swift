//
//  CustomerListRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import Foundation

class CustomerListRowModel: Hashable {
    let id: UUID
    var uiModel: ICustomerListTableViewCellUIModel

    init(uiModel: ICustomerListTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension CustomerListRowModel {
    static func == (lhs: CustomerListRowModel, rhs: CustomerListRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CustomerListRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
