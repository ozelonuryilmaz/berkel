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
        let _collections = self.collections.filter({ true == $0.isCalc })
        let totalKesiciCount = _collections.map({ $0.kesiciCount }).reduce(0, +).decimalString()
        let totalAyakciCount = _collections.map({ $0.ayakciCount }).reduce(0, +).decimalString()
        return "\(_collections.count) Gün, \(totalKesiciCount) Kesici, \(totalAyakciCount) Ayakçı, ..."
    }

    func nowDoubt() -> String {
        let payments = self.payments.map({ $0.payment }).reduce(0, +)
        let _collections = self.collections.filter({ true == $0.isCalc })
        var totalPrice: Int = 0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        let waitingPrice = totalPrice - payments

        return "\(payments.decimalString()) TL Ödendi, \(waitingPrice.decimalString()) TL Bekliyor"
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

    func getTotalPrice(data: WorkerCollectionModel) -> Int {
        let cavus: Int = Int(data.cavusPrice) * 1
        let kesici: Int = Int(data.kesiciPrice) * data.kesiciCount
        let ayakci: Int = Int(data.ayakciPrice) * data.ayakciCount
        let servis: Int = Int(data.servisPrice)
        let other: Int = Int(data.otherPrice)
        let total: Int = cavus + kesici + ayakci + servis + other

        return total
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

            let workerModel = WorkerModel(userId: responseModel.userId,
                                          cavusId: responseModel.cavusId,
                                          date: responseModel.date ?? "",
                                          cavusName: responseModel.cavusName,
                                          gardenOwner: responseModel.gardenOwner,
                                          desc: "nil",
                                          isActive: self.isActive,
                                          cavusPrice: responseModel.cavusPrice,
                                          kesiciPrice: responseModel.kesiciPrice,
                                          ayakciPrice: responseModel.ayakciPrice,
                                          servisPrice: responseModel.servisPrice)

            return WorkerDetailCollectionRowModel(uiModel:
                WorkerDetailCollectionTableViewCellUIModel(
                workerModel: workerModel,
                workerId: self.workerId,
                collectionId: responseModel.id,
                isCalc: responseModel.isCalc,
                isActive: self.isActive,
                date: responseModel.date?.dateFormatToAppDisplayType() ?? "",
                totalPrice: self.getTotalPrice(data: responseModel).decimalString(),
                gardenOwner: responseModel.gardenOwner,
                kesiciCount: responseModel.kesiciCount,
                ayakciCount: responseModel.ayakciCount,
                otherPrice: responseModel.otherPrice,
                isCharts: false)
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
