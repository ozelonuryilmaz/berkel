//
//  CavusListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

enum CavusListBuilder {

    static func generate(with data: CavusListPassData,
                         coordinator: ICavusListCoordinator,
                         outputDelegate: NewWorkerViewControllerOutputDelegate?) -> CavusListViewController {

        let repository = CavusListRepository()
        let uiModel = CavusListUIModel(data: data)
        let viewModel = CavusListViewModel(repository: repository,
                                           coordinator: coordinator,
                                           uiModel: uiModel)

        return CavusListViewController(viewModel: viewModel,
                                       outputDelegate: outputDelegate)
    }
}
