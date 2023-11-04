//
//  NewWorkerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

protocol INewWorkerUIModel {

    var cavusName: String { get }
    
    var newWorkerData: WorkerModel { get }
    var errorMessage: String? { get }

    var season: String { get }

    init(data: NewWorkerPassData)

    // Setter
    mutating func setCavusPrice(_ value: String)
    mutating func setKesiciPrice(_ value: String)
    mutating func setAyakciPrice(_ value: String)
    mutating func setServisPrice(_ value: String)
    mutating func setGarden(_ value: String)
    mutating func setDesc(_ value: String)
}

struct NewWorkerUIModel: INewWorkerUIModel {

    // MARK: Definitions
    let cavusId: String
    let cavusName: String
    
    // MARK: Initialize
    init(data: NewWorkerPassData) {
        self.cavusId = data.cavusId
        self.cavusName = data.cavusName
    }

    // MARK: Computed Props

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var gardenOwner: String = ""
    var desc: String = ""
    var cavusPrice: Double = 0
    var kesiciPrice: Double = 0
    var ayakciPrice: Double = 0
    var servisPrice: Double = 0

    var newWorkerData: WorkerModel {
        let date = Date().dateFormatterApiResponseType()
        return WorkerModel(
            userId: userId,
            cavusId: cavusId,
            date: date,
            cavusName: cavusName,
            gardenOwner: gardenOwner,
            desc: desc,
            isActive: true,
            cavusPrice: cavusPrice,
            kesiciPrice: kesiciPrice,
            ayakciPrice: ayakciPrice,
            servisPrice: servisPrice)
    }
}

// MARK: Props
extension NewWorkerUIModel {

    var errorMessage: String? {
        if cavusPrice < 1 {
            return "Lütfen günlük çavus ücreti giriniz"
        }

        if kesiciPrice == 0.0 {
            return "Lütfen günlük kesici ücreti giriniz"
        }

        if ayakciPrice == 0.0 {
            return "Lütfen günlük ayakçı ücreti yazınız"
        }

        if desc.isEmpty {
            return "Lütfen çavuş açıklaması giriniz"
        }


        return nil
    }
}

// MARK: Setter
extension NewWorkerUIModel {

    mutating func setCavusPrice(_ value: String) {
        self.cavusPrice = Double(value) ?? 0
    }

    mutating func setKesiciPrice(_ value: String) {
        self.kesiciPrice = Double(value) ?? 0
    }

    mutating func setAyakciPrice(_ value: String) {
        self.ayakciPrice = Double(value) ?? 0
    }

    mutating func setServisPrice(_ value: String) {
        self.servisPrice = Double(value) ?? 0
    }

    mutating func setGarden(_ value: String) {
        self.gardenOwner = value
    }

    mutating func setDesc(_ value: String) {
        self.desc = value
    }
}
