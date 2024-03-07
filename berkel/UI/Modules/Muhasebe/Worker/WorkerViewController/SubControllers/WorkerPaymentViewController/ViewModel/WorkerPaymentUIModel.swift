//
//  WorkerPaymentUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol IWorkerPaymentUIModel {

    var workerId: String { get }
    var season: String { get }
    var cavusName: String { get }
    
    var payment: Int { get }
    var data: WorkerPaymentModel { get }

    init(data: WorkerPaymentPassData)

    mutating func setDate(date: String?)
    mutating func setPayment(_ text: String)
    mutating func setDesc(_ text: String)
}

struct WorkerPaymentUIModel: IWorkerPaymentUIModel {

    // MARK: Definitions
    let workerId: String
    let cavusName: String
    let cavusId: String?

    // MARK: Initialize
    init(data: WorkerPaymentPassData) {
        self.workerId = data.workerId
        self.cavusName = data.cavusName
        self.cavusId = data.cavusId
    }

    var date: String? = Date().dateFormatterApiResponseType()
    var payment: Int = 0
    var desc: String? = nil

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var data: WorkerPaymentModel {
        return WorkerPaymentModel(
            id: nil,
            userId: userId,
            cavusId: cavusId,
            cavusName: cavusName,
            date: date,
            payment: payment,
            description: desc
        )
    }

    // MARK: Computed Props
}

// MARK: Props
extension WorkerPaymentUIModel {

}

// MARK: Setter
extension WorkerPaymentUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setPayment(_ text: String) {
        self.payment = Int(text) ?? 0
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }
}
