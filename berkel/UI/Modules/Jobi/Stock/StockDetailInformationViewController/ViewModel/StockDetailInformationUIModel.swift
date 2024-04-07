//
//  StockDetailInformationUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IStockDetailInformationUIModel {
    
    var limit: Int { get }
    var isHaveBuildData: Bool { get }
    
    var season: String { get }
    var stockId: String { get }
    var subStockId: String { get }

    var navigationTitle: String { get }
    var navigationSubTitle: String { get }

    init(data: StockDetailInformationPassData)

    func getUpdateStockPassData(type: UpdateStockType) -> UpdateStockPassData 
    
    mutating func setResponse(_ response: [UpdateStockModel])
    mutating func appendFirstItem(data: UpdateStockModel)
    mutating func buildSnapshot() -> StockDetailInfoSnapshot
    func updateSnapshot(currentSnapshot: StockDetailInfoSnapshot,
                        newDatas: [UpdateStockModel]) -> StockDetailInfoSnapshot

    func getLastCursor() -> [String]?
}

struct StockDetailInformationUIModel: IStockDetailInformationUIModel {

    // MARK: Definitions
    let stockModel: StockModel
    let subStockModel: SubStockModel

    var response: [UpdateStockModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false
    
    // MARK: Initialize
    init(data: StockDetailInformationPassData) {
        self.stockModel = data.stockModel
        self.subStockModel = data.subStockModel
    }

    // MARK: Computed Props

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
    
    var stockId: String {
        return stockModel.id ?? ""
    }
    
    var subStockId: String {
        return subStockModel.id ?? ""
    }

    var navigationTitle: String {
        return stockModel.stockName
    }

    var navigationSubTitle: String {
        return subStockModel.subStockName
    }
}

// MARK: Props
extension StockDetailInformationUIModel {
    
    mutating func setResponse(_ response: [UpdateStockModel]) {
        self.response.append(contentsOf: response)
    }

    func getUpdateStockPassData(type: UpdateStockType) -> UpdateStockPassData {
        return UpdateStockPassData(type: type, stockModel: self.stockModel, subStockModel: self.subStockModel)
    }

    mutating func appendFirstItem(data: UpdateStockModel) {
        if let firstIndex = self.response.firstIndex(where: { $0.id == data.id }) {
            self.response.remove(at: firstIndex)
        }
        self.response.insert(data, at: 0)
    }
    
    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }

        return [self.response.last?.date ?? ""] // order date olmalı
    }
}

// MARK: DataSource
extension StockDetailInformationUIModel {

    mutating func buildSnapshot() -> StockDetailInfoSnapshot {
        self.isHaveBuildData = true
        var snapshot = StockDetailInfoSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [StockDetailInfoRowModel] {
        let rowModels: [StockDetailInfoRowModel] = response.compactMap { item in
            return StockDetailInfoRowModel(uiModel: StockDetailInfoTableViewCellUIModel(updateStockModel: item))
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: StockDetailInfoSnapshot,
                        newDatas: [UpdateStockModel]) -> StockDetailInfoSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [StockDetailInfoRowModel] = []

        configuredItems = newDatas.compactMap({ item in
            return StockDetailInfoRowModel(uiModel: StockDetailInfoTableViewCellUIModel(updateStockModel: item))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}

