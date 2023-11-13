//
//  WorkerDetailCollectionTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import Foundation

protocol IWorkerDetailCollectionTableViewCellUIModel {

    var workerModel: WorkerModel { get }
    
    var workerId: String? { get }
    var collectionId: String? { get }
    var isCalc: Bool { get }
    var isActive: Bool { get }
    
    var date: String { get }
    var totalPrice: String { get }
    var gardenOwner: String { get }
    var kesiciCount: Int { get }
    var ayakciCount: Int { get }
    var otherPrice: Double { get }
}

struct WorkerDetailCollectionTableViewCellUIModel: IWorkerDetailCollectionTableViewCellUIModel {

    let workerModel: WorkerModel
    
    let workerId: String?
    let collectionId: String?
    var isCalc: Bool
    let isActive: Bool
    
    let date: String
    let totalPrice: String
    let gardenOwner: String
    let kesiciCount: Int
    let ayakciCount: Int
    let otherPrice: Double
}
