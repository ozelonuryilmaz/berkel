//
//  NewJBCPriceBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum NewJBCPriceBuilder {

    static func generate(with data: NewJBCPricePassData,
                         coordinator: INewJBCPriceCoordinator,
                         outputDelegate: NewJBCPriceViewControllerOutputDelegate?) -> NewJBCPriceViewController {

        let repository = NewJBCPriceRepository()
        let uiModel = NewJBCPriceUIModel(data: data)
        let viewModel = NewJBCPriceViewModel(repository: repository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return NewJBCPriceViewController(viewModel: viewModel,
                                         outputDelegate: outputDelegate)
    }
}
