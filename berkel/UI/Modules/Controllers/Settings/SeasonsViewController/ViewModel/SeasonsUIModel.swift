//
//  SeasonsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import UIKit

protocol ISeasonsUIModel {

    var isHiddenBackButton: Bool { get }

    init(data: SeasonsPassData)

    mutating func setResponse(_ response: [SeasonResponseModel])
    mutating func addSeason(_ season: SeasonResponseModel)

    func saveSeason(index: Int)

    func getNumberOfRowsInSection() -> Int
    func getItemCellUIModel(index: Int) -> SeasonsTableViewCellUIModel
}

struct SeasonsUIModel: ISeasonsUIModel {

    // MARK: Definitions
    private var items: [SeasonResponseModel] = []

    let isHiddenBackButton: Bool

    // MARK: Initialize
    init(data: SeasonsPassData) {
        self.isHiddenBackButton = data.isHiddenBackButton
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
