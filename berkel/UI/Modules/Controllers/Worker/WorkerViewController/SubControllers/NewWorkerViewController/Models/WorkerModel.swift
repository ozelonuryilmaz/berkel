//
//  WorkerModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import Foundation

struct WorkerModel: Codable {

    var id: String? = nil
    let userId: String?
    let cavusId: String?
    let date: String
    let cavusName: String
    let gardenOwner: String
    let desc: String
    var isActive: Bool
    let cavusPrice: Double
    let kesiciPrice: Double
    let ayakciPrice: Double
    let servisPrice: Double
}
