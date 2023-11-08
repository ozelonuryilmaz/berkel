//
//  WorkerTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Foundation

protocol IWorkerTableViewCellUIModel {

    var workerModel: WorkerModel { get }
    var workerId: String { get }
    var cavusName: String { get }
    var desc: String { get }
    var isActive: Bool { get }
}

struct WorkerTableViewCellUIModel: IWorkerTableViewCellUIModel {

    let workerModel: WorkerModel

    init(workerModel: WorkerModel) {
        self.workerModel = workerModel
    }
    
    var workerId: String {
        return workerModel.id ?? ""
    }

    var cavusName: String {
        return workerModel.cavusName
    }

    var desc: String {
        return workerModel.desc
    }
    
    var isActive: Bool {
        return workerModel.isActive
    }
}
