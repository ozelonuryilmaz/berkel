//
//  NewStockBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

enum NewStockBuilder {

    static func generate(with data: NewStockPassData,
                         coordinator: INewStockCoordinator,
                         outputDelegate: NewStockViewControllerOutputDelegate?) -> NewStockViewController {

        let repository = NewStockRepository()
        let uiModel = NewStockUIModel(data: data)
        let viewModel = NewStockViewModel(repository: repository,
                                          coordinator: coordinator,
                                          uiModel: uiModel)

        return NewStockViewController(viewModel: viewModel,
                                      outputDelegate: outputDelegate)
    }
}
