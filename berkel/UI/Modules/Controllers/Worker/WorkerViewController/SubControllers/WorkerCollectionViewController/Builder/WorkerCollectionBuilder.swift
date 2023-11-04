//
//  WorkerCollectionBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

enum WorkerCollectionBuilder {

    static func generate(with data: WorkerCollectionPassData,
                         coordinator: IWorkerCollectionCoordinator) -> WorkerCollectionViewController {

        let repository = WorkerCollectionRepository()
        let uiModel = WorkerCollectionUIModel(data: data)
        let viewModel = WorkerCollectionViewModel(repository: repository,
                                                  coordinator: coordinator,
                                                  uiModel: uiModel)

        return WorkerCollectionViewController(viewModel: viewModel)
    }
}
