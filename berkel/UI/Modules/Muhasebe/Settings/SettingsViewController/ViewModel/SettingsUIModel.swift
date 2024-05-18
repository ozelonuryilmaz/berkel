//
//  SettingsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol ISettingsUIModel {

    var season: String { get }

    init()

    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> SettingsSectionUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> ISettingsRowModel
    func isLastSection(section: Int) -> Bool
    func isVisibleSeperatorRow(indexPath: IndexPath) -> Bool
}

struct SettingsUIModel: ISettingsUIModel {

    private var sectionUIModels = [SettingsSectionUIModel]()

    // MARK: Definitions

    // MARK: Initialize
    init() {
        self.syncronizedSectionUIModels()
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
    
    var userId: String? {
        return UserManager.shared.userId
    }

    // MARK: Computed Props
    mutating func syncronizedSectionUIModels() {
        self.mappedSectionUIModels()
    }
}

// MARK: Props
extension SettingsUIModel {

    mutating func mappedSectionUIModels() {
        self.sectionUIModels = [
            SettingsSectionUIModel.init(sectionType: .list,
                                        rowUIModels: generateListRowUIModels(),
                                        isVisibleSection: true),
            SettingsSectionUIModel.init(sectionType: .gelirGider,
                                        rowUIModels: generateGelirGiderCizelgesiRowUIModels(),
                                        isVisibleSection: true),
            SettingsSectionUIModel.init(sectionType: .ayarlar,
                                        rowUIModels: generateAyarlarRowUIModels(),
                                        isVisibleSection: true),
            SettingsSectionUIModel.init(sectionType: .hesap,
                                        rowUIModels: generateHesapRowUIModels(),
                                        isVisibleSection: false)
        ]
    }

    // Liste
    func generateListRowUIModels() -> [ISettingsRowModel] {
        var tempArray = [ISettingsRowModel]()
        switch otherModule {
        case .accouting:
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .saticiList)))
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .cavusList)))
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .musteriList)))
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .otherList)))
        case .jobi:
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .jbMusteriList)))
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .otherList)))
        }
        
        return tempArray
    }

    // Gelir Gider Çizelgesi
    func generateGelirGiderCizelgesiRowUIModels() -> [ISettingsRowModel] {
        var tempArray = [ISettingsRowModel]()
        switch otherModule {
        case .accouting:
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .alisGelirGiderCizergesi)))
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .isciGelirGiderCizergesi)))
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .satisGelirGiderCizergesi)))
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .otherGelirGiderCizergesi)))
        case .jobi:
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .otherGelirGiderCizergesi)))
        }
        
        return tempArray
    }

    // Ayarlar
    func generateAyarlarRowUIModels() -> [ISettingsRowModel] {
        var tempArray = [ISettingsRowModel]()
        tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .sezonlar)))

        if jobiCollection == "jobi" && jobiBahadirKey != userId {
            if userId == jobiAdminKey {
                tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .userAuths)))
            }
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .moduleSelection)))
        }

        return tempArray
    }

    // Hesap
    func generateHesapRowUIModels() -> [ISettingsRowModel] {
        var tempArray = [ISettingsRowModel]()
        if userId != jobiAdminKey && userId != jobiBahadirKey {
            tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .hesabiSil)))
        }
        tempArray.append(SettingsItemCellDataRow(uiModel: SettingsItemCellUIModel(cellType: .cikisYap)))
        return tempArray
    }
}

// MARK: Table View
extension SettingsUIModel {

    func getNumberOfItemsInSection() -> Int {
        return sectionUIModels.count
    }

    func getNumberOfItemsInRow(section: Int) -> Int {
        return getSectionUIModel(section: section).numberOfRows()
    }

    func getSectionUIModel(section: Int) -> SettingsSectionUIModel {
        return self.sectionUIModels[section]
    }

    func getItemCellUIModel(indexPath: IndexPath) -> ISettingsRowModel {
        return getSectionUIModel(section: indexPath.section).getItemCellUIModel(index: indexPath.row)
    }

    func isLastSection(section: Int) -> Bool {
        return section == getNumberOfItemsInSection() - 1
    }
}

// MARK: Visibility
extension SettingsUIModel {

    func isVisibleSeperatorRow(indexPath: IndexPath) -> Bool {
        return indexPath.row != getSectionUIModel(section: indexPath.section).numberOfRows() - 1
    }
}
