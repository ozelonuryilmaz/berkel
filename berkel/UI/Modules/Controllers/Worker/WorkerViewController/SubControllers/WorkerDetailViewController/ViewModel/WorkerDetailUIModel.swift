//
//  WorkerDetailUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol IWorkerDetailUIModel {

    var season: String { get }

    var workerId: String { get }
    var cavusName: String { get }
    var cavusId: String { get }
    var isActive: Bool { get }

    var collections: [WorkerCollectionModel] { get }

    init(data: WorkerDetailPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setActive(isActive: Bool)

    mutating func setCollectionResponse(data: [WorkerCollectionModel])
    mutating func setPaymentResponse(data: [WorkerPaymentModel])

    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool)

    func getCollection(workerId: String?) -> WorkerCollectionModel?

    // Collection
    mutating func buildCollectionSnapshot() -> WorkerDetailCollectionSnapshot

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> WorkerDetailPaymentTableViewCellUIModel
}

struct WorkerDetailUIModel: IWorkerDetailUIModel {

    // MARK: Definitions
    let workerId: String
    let cavusName: String
    let cavusId: String
    var isActive: Bool

    // MARK: Initialize
    init(data: WorkerDetailPassData) {
        self.workerId = data.workerId
        self.cavusName = data.cavusName
        self.cavusId = data.cavusId
        self.isActive = data.isActive
    }

    var collections: [WorkerCollectionModel] = []
    var payments: [WorkerPaymentModel] = []

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    mutating func setActive(isActive: Bool) {
        self.isActive = isActive
    }

    // MARK: Computed Props

    func oldDoubt() -> String {
        return "***"
    }

    func nowDoubt() -> String {
        return "***"
    }

    func getCollection(workerId: String?) -> WorkerCollectionModel? {
        if let index = self.collections.firstIndex(where: { $0.id == workerId }) {
            return self.collections[index]
        } else {
            return nil
        }
    }
}

// MARK: Props
extension WorkerDetailUIModel {

    mutating func setCollectionResponse(data: [WorkerCollectionModel]) {
        self.collections = data
    }

    mutating func setPaymentResponse(data: [WorkerPaymentModel]) {
        self.payments = data
    }

    // Calc aktifleştir
    mutating func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        if let index = self.collections.firstIndex(where: { $0.id == collectionId }) {
            self.collections[index].isCalc = isCalc
        }
    }
}

// MARK: Collection
extension WorkerDetailUIModel {

    mutating func buildCollectionSnapshot() -> WorkerDetailCollectionSnapshot {
        var snapshot = WorkerDetailCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    private func prepareCollectionSnapshotRowModel() -> [WorkerDetailCollectionRowModel] {
        let rowModels: [WorkerDetailCollectionRowModel] = collections.compactMap { responseModel in
            let totalPrice: String = ""
            
            return WorkerDetailCollectionRowModel(uiModel:
                WorkerDetailCollectionTableViewCellUIModel(
                workerId: self.workerId,
                collectionId: responseModel.id,
                isCalc: responseModel.isCalc,
                isActive: self.isActive,
                date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                totalPrice: totalPrice,
                ayakciCount: responseModel.ayakciCount.decimalString(),
                kesiciCount: responseModel.kesiciCount.decimalString())
            )
        }
        return rowModels
    }

}

// MARK: TableView Helper
extension WorkerDetailUIModel {

    func getNumberOfItemsInSection() -> Int {
        return self.payments.count
    }

    func getCellUIModel(at index: Int) -> WorkerDetailPaymentTableViewCellUIModel {
        return WorkerDetailPaymentTableViewCellUIModel(payment: self.payments[index])
    }
}
