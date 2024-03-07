//
//  WorkerImageModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 8.01.2024.
//

import Foundation

struct WorkerImageModel: Codable {

    var id: String?
    let cavusId: String
    let userId: String?
    let workerId: String
    let workerProductName: String

    let date: String?
    let description: String?
    let imageUrl: String
}
