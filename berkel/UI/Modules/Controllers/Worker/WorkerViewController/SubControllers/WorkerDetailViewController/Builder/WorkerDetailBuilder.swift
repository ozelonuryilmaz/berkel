//
//  WorkerDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

enum WorkerDetailBuilder {

    static func generate(with data: WorkerDetailPassData,
                         coordinator: IWorkerDetailCoordinator) -> WorkerDetailViewController {

        let repository = WorkerDetailRepository()
        let uiModel = WorkerDetailUIModel(data: data)
        let viewModel = WorkerDetailViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return WorkerDetailViewController(viewModel: viewModel)
    }
}
