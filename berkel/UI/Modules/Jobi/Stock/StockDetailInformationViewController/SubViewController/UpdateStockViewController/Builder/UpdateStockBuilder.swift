//
//  UpdateStockBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum UpdateStockBuilder {

    static func generate(with data: UpdateStockPassData,
                         coordinator: IUpdateStockCoordinator,
                         outputDelegate: UpdateStockViewControllerOutputDelegate?) -> UpdateStockViewController {

        let repository = UpdateStockRepository()
        let jobiStockRepository = JobiStockRepository()
        let uiModel = UpdateStockUIModel(data: data)
        let viewModel = UpdateStockViewModel(repository: repository,
                                             jobiStockRepository: jobiStockRepository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return UpdateStockViewController(viewModel: viewModel,
                                         outputDelegate: outputDelegate)
    }
}
