//
//  OrderUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IOrderUIModel {
    
    var limit: Int { get }
    var season: String { get }
    var isHaveBuildData: Bool { get }

    init()
    
    func getLastCursor() -> [String]?
    mutating func setResponse(_ response: [OrderModel])
    mutating func appendFirstItem(data: OrderModel)

    mutating func updateIsActive(orderId: String?, isActive: Bool)

    // DataSource
    mutating func buildSnapshot() -> OrderSnapshot
    func updateSnapshot(currentSnapshot: OrderSnapshot,
                        newDatas: [OrderModel]) -> OrderSnapshot
}

struct OrderUIModel: IOrderUIModel {

	// MARK: Definitions
    var response: [OrderModel] = []
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

    mutating func setResponse(_ response: [OrderModel]) {
        self.response.append(contentsOf: response)
    }
}

// MARK: Props
extension OrderUIModel {

    mutating func appendFirstItem(data: OrderModel) {
        self.response.insert(data, at: 0)
    }

    mutating func updateIsActive(orderId: String?, isActive: Bool) {
        if let index = self.response.firstIndex(where: { $0.id == orderId }) {
            self.response[index].isActive = isActive
        }
    }
}

// MARK: DataSource
extension OrderUIModel {

    mutating func buildSnapshot() -> OrderSnapshot {
        self.isHaveBuildData = true
        var snapshot = OrderSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareSnapshotRowModel() -> [OrderRowModel] {
        let rowModels: [OrderRowModel] = response.compactMap { orderModel in

            return OrderRowModel(
                uiModel: OrderTableViewCellUIModel(orderModel: orderModel)
            )
        }
        return rowModels
    }

    func updateSnapshot(currentSnapshot: OrderSnapshot,
                        newDatas: [OrderModel]) -> OrderSnapshot {

        var snapshot = currentSnapshot
        var configuredItems: [OrderRowModel] = []

        configuredItems = newDatas.compactMap({ orderModel in

            return OrderRowModel(uiModel: OrderTableViewCellUIModel(orderModel: orderModel))
        })

        snapshot.appendItems(configuredItems) // Ekleme olduğu için append. Yenileme olduğunda reload kullanılır

        return snapshot
    }
}
