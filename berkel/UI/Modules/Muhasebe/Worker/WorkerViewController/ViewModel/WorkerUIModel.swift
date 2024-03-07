//
//  WorkerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol IWorkerUIModel {

    var limit: Int { get }
    var season: String { get }
    var isHaveBuildData: Bool { get }

    init()

    func getLastCursor() -> [String]?
    mutating func setResponse(_ response: [WorkerModel])
    mutating func appendFirstItem(data: WorkerModel)

    mutating func updateIsActive(workerId: String?, isActive: Bool)

    // DataSource
    mutating func buildSnapshot() -> WorkerSnapshot
    func updateSnapshot(currentSnapshot: WorkerSnapshot,
                        newDatas: [WorkerModel]) -> WorkerSnapshot
}

struct WorkerUIModel: IWorkerUIModel {

    // MARK: Definitions
    var response: [WorkerModel] = []
    let limit = 20
    var isHaveBuildData: Bool = false

    // MARK: Initialize
    init() { }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    func getLastCursor() -> [String]? {
        if response.isEmpty {
            return nil
        }
        return [self.response.last?.date ?? ""] // order date olmalı
    }

    mutating func setResponse(_ response: [WorkerModel]) {
        self.response.append(contentsOf: response)
    }

    // MARK: Computed Props
}

// MARK: Props
extension WorkerUIModel {

    mutating func appendFirstItem(data: WorkerModel) {
        self.response.insert(data, at: 0)
    }

    mutating func updateIsActive(workerId: String?, isActive: Bool) {
        if let index = self.response.firstIndex(where: { $0.id == workerId }) {
            self.response[index].isActive = isActive
        }
    }
}

// MARK: DataSource
extension WorkerUIModel {

    mutating func buildSnapshot() -> WorkerSnapshot {
        self.isHaveBuildData = true
        var snapshot = WorkerSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [WorkerRowModel] {
        let rowModels: [WorkerRowModel] = response.compactMap { workerModel in

            return WorkerRowModel(
                uiModel: WorkerTableViewCellUIModel(workerModel: workerModel)
            )
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: WorkerSnapshot,
                        newDatas: [WorkerModel]) -> WorkerSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [WorkerRowModel] = []

        configuredItems = newDatas.compactMap({ workerModel in

            return WorkerRowModel(uiModel: WorkerTableViewCellUIModel(workerModel: workerModel))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}
