//
//  WorkerDetailCollectionRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import Foundation

class WorkerDetailCollectionRowModel: Hashable {
    let id: UUID
    var uiModel: IWorkerDetailCollectionTableViewCellUIModel

    init(uiModel: IWorkerDetailCollectionTableViewCellUIModel) {
        self.id = UUID()
        self.uiModel = uiModel
    }
}

extension WorkerDetailCollectionRowModel {
    static func == (lhs: WorkerDetailCollectionRowModel, rhs: WorkerDetailCollectionRowModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WorkerDetailCollectionRowModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
