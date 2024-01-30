//
//  OtherUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol IOtherUIModel {
    
    var limit: Int { get }
    var season: String { get }
    var isHaveBuildData: Bool { get }
    
	 init()

    func getLastCursor() -> [String]?
    mutating func setResponse(_ response: [OtherModel])
    mutating func appendFirstItem(data: OtherModel)

    mutating func updateIsActive(otherId: String?, isActive: Bool)

    // DataSource
    mutating func buildSnapshot() -> OtherSnapshot
    func updateSnapshot(currentSnapshot: OtherSnapshot,
                        newDatas: [OtherModel]) -> OtherSnapshot
} 

struct OtherUIModel: IOtherUIModel {

	// MARK: Definitions
    var response: [OtherModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false

	// MARK: Initialize
    init() { }

    // MARK: Computed Props
    
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
    
    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }
        return [self.response.last?.date ?? ""] // order date olmalı
    }

    mutating func setResponse(_ response: [OtherModel]) {
        self.response.append(contentsOf: response)
    }
}

// MARK: Props
extension OtherUIModel {

    mutating func appendFirstItem(data: OtherModel) {
        self.response.insert(data, at: 0)
    }

    mutating func updateIsActive(otherId: String?, isActive: Bool) {
        if let index = self.response.firstIndex(where: { $0.id == otherId }) {
            self.response[index].isActive = isActive
        }
    }
}

// MARK: DataSource
extension OtherUIModel {

    mutating func buildSnapshot() -> OtherSnapshot {
        self.isHaveBuildData = true
        var snapshot = OtherSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [OtherRowModel] {
        let rowModels: [OtherRowModel] = response.compactMap { otherModel in

            return OtherRowModel(
                uiModel: OtherTableViewCellUIModel(otherModel: otherModel)
            )
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: OtherSnapshot,
                        newDatas: [OtherModel]) -> OtherSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [OtherRowModel] = []

        configuredItems = newDatas.compactMap({ otherModel in

            return OtherRowModel(uiModel: OtherTableViewCellUIModel(otherModel: otherModel))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}

