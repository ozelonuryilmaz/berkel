//
//  SettingsSectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.12.2023.
//

import Foundation

struct SettingsSectionUIModel {

    let sectionType: SettingsSectionType
    private let rowUIModels: [ISettingsRowModel]
    private let isVisibleSection: Bool

    var _isVisibleSection: Bool {
        if isVisibleSection == true {
            return rowUIModels.count > 0
        }
        return isVisibleSection
    }

    init(sectionType: SettingsSectionType,
         rowUIModels: [ISettingsRowModel],
         isVisibleSection: Bool) {
        self.sectionType = sectionType
        self.rowUIModels = rowUIModels
        self.isVisibleSection = isVisibleSection
    }

    var sectionTitle: String {
        return sectionType.sectionTitle
    }

    func numberOfRows() -> Int {
        return rowUIModels.count
    }

    func getItemCellUIModel(index: Int) -> ISettingsRowModel {
        return rowUIModels[index]
    }
}
