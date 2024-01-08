//
//  WorkerChartsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 8.01.2024.
//

import UIKit

protocol IWorkerChartsUIModel {
    
    var season: String { get }
    var workerResponse: [WorkerModel] { get }
    var workerCollectionResponse: [WorkerCollectionModel] { get }

	 init(data: WorkerChartsPassData)

    func oldDoubt() -> String
    func nowDoubt() -> String

    mutating func setResponseList(_ response: [WorkerModel])
    mutating func setCollectionResponse(_ response: [WorkerCollectionModel])
    mutating func setPaymentResponse(_ response: [WorkerPaymentModel])

    mutating func buildCollectionSnapshot() -> WorkerDetailCollectionSnapshot
} 

struct WorkerChartsUIModel: IWorkerChartsUIModel {

	// MARK: Definitions
    var workerResponse: [WorkerModel] = []
    var workerCollectionResponse: [WorkerCollectionModel] = []
    var workerPaymentResponse: [WorkerPaymentModel] = []

	// MARK: Initialize
    init(data: WorkerChartsPassData) {

    }
    
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    // MARK: Computed Props
}

// MARK: Logic
extension WorkerChartsUIModel {

    mutating func setResponseList(_ response: [WorkerModel]) {
        self.workerResponse = response
    }

    mutating func setCollectionResponse(_ response: [WorkerCollectionModel]) {
        self.workerCollectionResponse.append(contentsOf: response)
    }

    mutating func setPaymentResponse(_ response: [WorkerPaymentModel]) {
        self.workerPaymentResponse.append(contentsOf: response)
    }
}

// MARK: Props
extension WorkerChartsUIModel {

    func oldDoubt() -> String {
        let _collections = self.workerCollectionResponse.filter({ true == $0.isCalc })
        var totalPrice: Int = 0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        return "Toplam: \(totalPrice.decimalString()) TL"
    }

    func nowDoubt() -> String {
        let payments = self.workerPaymentResponse.map({ $0.payment }).reduce(0, +)
        let _collections = self.workerCollectionResponse.filter({ true == $0.isCalc })
        var totalPrice: Int = 0
        for c in _collections {
            totalPrice += self.getTotalPrice(data: c)
        }
        let waitingPrice = totalPrice - payments

        return "\(payments.decimalString()) TL Ödendi, \(waitingPrice.decimalString()) TL Bekliyor"
    }

    private func getTotalPrice(data: WorkerCollectionModel) -> Int {
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
extension WorkerChartsUIModel {

    mutating func buildCollectionSnapshot() -> WorkerDetailCollectionSnapshot {
        var snapshot = WorkerDetailCollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(prepareCollectionSnapshotRowModel(), toSection: .main)
        return snapshot
    }

    // CollecitonModel içerisinde rastgele birden fazla müşteri siparişleri bulunuyor.
    // Aynı müşterilerin toplam siparişleri toplanıyor.
    private func prepareCollectionSnapshotRowModel() -> [WorkerDetailCollectionRowModel] {
        let data = workerCollectionResponse.filter({ true == $0.isCalc })
        let collections: [String: [WorkerCollectionModel]] = Dictionary(grouping: data, by: { $0.cavusId ?? "-1" })
        var rowModels: [WorkerDetailCollectionRowModel] = []

        let keys = Array(collections.keys)
        for key in keys {
            var cavusName: String = ""
            var totalPrice: Int = 0

            if let collection = collections[key] {
                cavusName = collection.first?.cavusName ?? ""
                for c in collection {
                    totalPrice += self.getTotalPrice(data: c)
                }
            }

            let payments = self.workerPaymentResponse.filter({ $0.cavusId == key }).map({ $0.payment }).reduce(0, +)
            let waitingPrice = totalPrice - payments

            let chartTotal = "Toplam: \(totalPrice.decimalString()) TL"
            let chartTotalPrice = "\(payments.decimalString()) TL Ödendi, \(waitingPrice.decimalString()) TL Bekliyor"

            let data = WorkerDetailCollectionTableViewCellUIModel(workerModel: nil,
                                                                  workerId: nil,
                                                                  collectionId: nil,
                                                                  isCalc: true,
                                                                  isActive: false,
                                                                  date: cavusName,
                                                                  totalPrice: chartTotalPrice,
                                                                  gardenOwner: chartTotal,
                                                                  kesiciCount: 0,
                                                                  ayakciCount: 0,
                                                                  otherPrice: 0.0,
                                                                  isCharts: true)

            rowModels.append(WorkerDetailCollectionRowModel(uiModel: data))
        }

        return rowModels

    }

}
