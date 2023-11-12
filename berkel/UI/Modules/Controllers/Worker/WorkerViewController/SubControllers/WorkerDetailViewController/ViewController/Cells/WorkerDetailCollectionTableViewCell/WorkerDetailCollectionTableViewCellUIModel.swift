//
//  WorkerDetailCollectionTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import Foundation

protocol IWorkerDetailCollectionTableViewCellUIModel {

    var workerId: String? { get }
    var collectionId: String? { get }
    var isCalc: Bool { get }
    var isActive: Bool { get }
    
    var date: String { get }
    var totalPrice: String { get }
    var ayakciCount: String { get }
    var kesiciCount: String { get }
}

struct WorkerDetailCollectionTableViewCellUIModel: IWorkerDetailCollectionTableViewCellUIModel {

    let workerId: String?
    let collectionId: String?
    var isCalc: Bool
    let isActive: Bool
    
    let date: String
    let totalPrice: String
    let ayakciCount: String
    let kesiciCount: String
}
