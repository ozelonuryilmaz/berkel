//
//  WorkerCollectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol IWorkerCollectionUIModel {

    var workerModel: WorkerModel { get }
    var cavusName: String { get }

    init(data: WorkerCollectionPassData)

    func getTotalPrice() -> String

    // Setter
    mutating func setDate(date: String?)
    mutating func setGardenOwner(_ text: String)
    mutating func setKesiciCount(_ text: String)
    mutating func setAyakciCount(_ text: String)
    mutating func setCavusPrice(_ text: String)
    mutating func setKesiciPrice(_ text: String)
    mutating func setAyakciPrice(_ text: String)
    mutating func setServicePrice(_ text: String)
    mutating func setOtherPrice(_ text: String)
}

struct WorkerCollectionUIModel: IWorkerCollectionUIModel {

    // MARK: Definitions
    let workerModel: WorkerModel

    // MARK: Initialize
    init(data: WorkerCollectionPassData) {
        self.workerModel = data.workerModel

        // Sabit fiyatlar UIModel'daki değişkene aktarılıyor.
        self.gardenOwner = data.workerModel.gardenOwner
        self.cavusPrice = data.workerModel.cavusPrice
        self.ayakciPrice = data.workerModel.ayakciPrice
        self.kesiciPrice = data.workerModel.kesiciPrice
        self.servisPrice = data.workerModel.servisPrice
    }

    // MARK: Computed Props

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var cavusName: String {
        return workerModel.cavusName
    }

    var let_gardenOwner: String {
        return workerModel.gardenOwner
    }

    var let_cavusPrice: Double {
        return workerModel.cavusPrice
    }

    var let_kesiciPrice: Double {
        return workerModel.kesiciPrice
    }

    var let_ayakciPrice: Double {
        return workerModel.ayakciPrice
    }

    var let_servisPrice: Double {
        return workerModel.servisPrice
    }

    var date: String? = Date().dateFormatterApiResponseType()

    var gardenOwner: String = ""
    var kesiciCount: Int = 0
    var ayakciCount: Int = 0

    var cavusPrice: Double = 0.0 // Bazı sabitler FB'den alınmalı
    var ayakciPrice: Double = 0.0
    var kesiciPrice: Double = 0.0
    var servisPrice: Double = 0.0
    var otherPrice: Double = 0.0
}

// MARK: Props
extension WorkerCollectionUIModel {

    func getTotalPrice() -> String {
        let cavus: Int = Int(cavusPrice) * 1
        let kesici: Int = Int(kesiciPrice) * self.kesiciCount
        let ayakci: Int = Int(ayakciPrice) * self.ayakciCount
        let servis: Int = Int(servisPrice)
        let other: Int = Int(otherPrice)
        let total = cavus + kesici + ayakci + servis + other

        return total.decimalString()
    }
}

// MARK: Setter
internal extension WorkerCollectionUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setGardenOwner(_ text: String) {
        self.gardenOwner = text.isEmpty ? self.let_gardenOwner: text
    }

    mutating func setKesiciCount(_ text: String) {
        self.kesiciCount = Int(text) ?? 0
    }

    mutating func setAyakciCount(_ text: String) {
        self.ayakciCount = Int(text) ?? 0
    }

    mutating func setCavusPrice(_ text: String) {
        self.cavusPrice = text.isEmpty ? self.let_cavusPrice: Double(text) ?? self.let_cavusPrice
    }

    mutating func setKesiciPrice(_ text: String) {
        self.kesiciPrice = text.isEmpty ? self.let_kesiciPrice: Double(text) ?? self.kesiciPrice
    }

    mutating func setAyakciPrice(_ text: String) {
        self.ayakciPrice = text.isEmpty ? self.let_ayakciPrice: Double(text) ?? self.ayakciPrice
    }

    mutating func setServicePrice(_ text: String) {
        self.servisPrice = text.isEmpty ? self.let_servisPrice: Double(text) ?? self.let_servisPrice
    }

    mutating func setOtherPrice(_ text: String) {
        self.otherPrice = Double(text) ?? 0
    }


}
