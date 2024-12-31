//
//  SeasonsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import UIKit

protocol ISeasonsUIModel {

    var isHiddenBackButton: Bool { get }
    var isAppSeasonSelection: Bool { get }

    init(data: SeasonsPassData)

    mutating func setResponse(_ response: [SeasonResponseModel])
    mutating func addSeason(_ season: SeasonResponseModel)

    func isHaveSeason(_ season: String) -> Bool
    func saveSeason(index: Int)

    func getNumberOfRowsInSection() -> Int
    func getItemCellUIModel(index: Int) -> SeasonsTableViewCellUIModel
}

struct SeasonsUIModel: ISeasonsUIModel {

    // MARK: Definitions
    private var items: [SeasonResponseModel] = []

    let isHiddenBackButton: Bool
    let isAppSeasonSelection: Bool

    // MARK: Initialize
    init(data: SeasonsPassData) {
        self.isHiddenBackButton = data.isHiddenBackButton
        self.isAppSeasonSelection = data.isAppSeasonSelection
    }

    func isHaveSeason(_ season: String) -> Bool {
        return items.contains(where: { $0.season == season })
    }

    // MARK: Computed Props

    mutating func setResponse(_ response: [SeasonResponseModel]) {
        self.items = response
    }

    mutating func addSeason(_ season: SeasonResponseModel) {
        self.items.append(season)
    }

    func getNumberOfRowsInSection() -> Int {
        return self.items.count
    }

    func getItemCellUIModel(index: Int) -> SeasonsTableViewCellUIModel {
        return SeasonsTableViewCellUIModel(season: self.items[index].season)
    }
}

// MARK: Props
extension SeasonsUIModel {

    func saveSeason(index: Int) {
        UserDefaultsManager.shared.set(value: self.items[index].season, key: .season)
    }
}
