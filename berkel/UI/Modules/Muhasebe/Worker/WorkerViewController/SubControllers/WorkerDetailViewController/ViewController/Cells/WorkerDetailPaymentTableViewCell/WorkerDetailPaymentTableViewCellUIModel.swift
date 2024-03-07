//
//  WorkerDetailPaymentTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import Foundation

protocol IWorkerDetailPaymentTableViewCellUIModel {

    var payment: WorkerPaymentModel { get }
    var isActive: Bool { get }
}

struct WorkerDetailPaymentTableViewCellUIModel: IWorkerDetailPaymentTableViewCellUIModel {
    
    let payment: WorkerPaymentModel
    let isActive: Bool
}
