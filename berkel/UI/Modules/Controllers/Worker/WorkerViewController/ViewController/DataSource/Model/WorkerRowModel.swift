//
//  WorkerRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Foundation

class WorkerRowModel: Hashable {
    let id: UUID
    var uiModel: IWorkerTableViewCellUIModel

    init(uiModel: IWorkerTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension WorkerRowModel {
    static func == (lhs: WorkerRowModel, rhs: WorkerRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WorkerRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
