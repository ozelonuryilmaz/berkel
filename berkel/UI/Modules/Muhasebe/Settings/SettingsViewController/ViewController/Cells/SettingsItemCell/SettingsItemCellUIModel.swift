//
//  SettingsItemCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.12.2023.
//

import Foundation

struct SettingsItemCellUIModel {

    let cellType: SettingsCellType

    init(cellType: SettingsCellType) {
        self.cellType = cellType
    }

    var _cellType: SettingsCellType { cellType }

    var rowTitle: String {
        return cellType.rowTitle
    }
}
