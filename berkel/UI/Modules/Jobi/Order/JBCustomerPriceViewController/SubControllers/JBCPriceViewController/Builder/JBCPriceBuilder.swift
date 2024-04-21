//
//  JBCPriceBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum JBCPriceBuilder {

    static func generate(with data: JBCPricePassData,
                         coordinator: IJBCPriceCoordinator,
                         outputDelegate: JBCPriceViewControllerOutputDelegate?) -> JBCPriceViewController {

        let repository = JBCPriceRepository()
        let uiModel = JBCPriceUIModel(data: data)
        let viewModel = JBCPriceViewModel(repository: repository,
                                          coordinator: coordinator,
                                          uiModel: uiModel)

        return JBCPriceViewController(viewModel: viewModel,
                                      outputDelegate: outputDelegate)
    }
}
