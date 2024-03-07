//
//  WorkerPaymentBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

enum WorkerPaymentBuilder {

    static func generate(with data: WorkerPaymentPassData,
                         coordinator: IWorkerPaymentCoordinator) -> WorkerPaymentViewController {

        let repository = WorkerPaymentRepository()
        let uiModel = WorkerPaymentUIModel(data: data)
        let viewModel = WorkerPaymentViewModel(repository: repository,
                                               coordinator: coordinator,
                                               uiModel: uiModel)

        return WorkerPaymentViewController(viewModel: viewModel)
    }
}
