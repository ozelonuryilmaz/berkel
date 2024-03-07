//
//  CostBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

enum CostBuilder {

    static func generate(coordinator: ICostCoordinator) -> CostViewController {

        let repository = CostRepository()
        let uiModel = CostUIModel()
        let viewModel = CostViewModel(repository: repository,
                                      coordinator: coordinator,
                                      uiModel: uiModel)

        return CostViewController(viewModel: viewModel)
    }
}
