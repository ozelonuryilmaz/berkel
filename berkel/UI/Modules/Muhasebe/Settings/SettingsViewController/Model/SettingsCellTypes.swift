//
//  SettingsCellTypes.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.12.2023.
//

import Foundation

enum SettingsRowType {
    case SETTINGS_ITEM
}

protocol ISettingsRowModel {
    var rowType: SettingsRowType { get }
}

extension ISettingsRowModel {

    func castRowModel<T: ISettingsRowModel>(_ type: T.Type) -> T {
        guard let castModel = self as? T else { fatalError("undefined row model -> \(T.self)") }
        return castModel
    }
}

struct SettingsItemCellDataRow: ISettingsRowModel {

    var uiModel: SettingsItemCellUIModel

    var rowType: SettingsRowType {
        return .SETTINGS_ITEM
    }

    init(uiModel: SettingsItemCellUIModel) {
        self.uiModel = uiModel
    }
}
