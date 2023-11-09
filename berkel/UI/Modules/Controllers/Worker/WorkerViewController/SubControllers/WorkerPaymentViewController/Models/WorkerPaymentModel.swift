//
//  WorkerPaymentModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.11.2023.
//

import Foundation

struct WorkerPaymentModel: Codable {

    var id: String?
    let userId: String?
    let date: String?
    let payment: Int
    let description: String?
}
