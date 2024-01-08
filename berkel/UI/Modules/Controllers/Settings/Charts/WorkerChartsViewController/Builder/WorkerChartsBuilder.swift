//
//  WorkerChartsBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 8.01.2024.
//

import UIKit

enum WorkerChartsBuilder {

    static func generate(with data: WorkerChartsPassData,
                         coordinator: IWorkerChartsCoordinator) -> WorkerChartsViewController {

        let repository = WorkerChartsRepository()
        let uiModel = WorkerChartsUIModel(data: data)
        let viewModel = WorkerChartsViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return WorkerChartsViewController(viewModel: viewModel)
    }
}
