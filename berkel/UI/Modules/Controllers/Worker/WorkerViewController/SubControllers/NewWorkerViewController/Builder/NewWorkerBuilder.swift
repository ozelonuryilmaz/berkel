//
//  NewWorkerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

enum NewWorkerBuilder {

    static func generate(with data: NewWorkerPassData,
                         coordinator: INewWorkerCoordinator) -> NewWorkerViewController {

        let repository = NewWorkerRepository()
        let uiModel = NewWorkerUIModel(data: data)
        let viewModel = NewWorkerViewModel(repository: repository,
                                           coordinator: coordinator,
                                           uiModel: uiModel)

        return NewWorkerViewController(viewModel: viewModel)
    }
}
