//
//  WorkerCollectionModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 8.11.2023.
//

import Foundation

struct WorkerCollectionModel: Codable {
    
    var id: String?
    let userId: String?
    let cavusId: String?
    
    var isCalc: Bool
    let date: String?
    
    let cavusName: String
    let gardenOwner: String
    let kesiciCount: Int
    let ayakciCount: Int
    let cavusPrice: Double
    let kesiciPrice: Double
    let ayakciPrice: Double
    let servisPrice: Double
    let otherPrice: Double
}
