//
//  NewOrderBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum NewOrderBuilder {

    static func generate(with data: NewOrderPassData,
                         coordinator: INewOrderCoordinator,
                         outputDelegate: NewOrderViewControllerOutputDelegate?) -> NewOrderViewController {

        let repository = NewOrderRepository()
        let uiModel = NewOrderUIModel(data: data)
        let viewModel = NewOrderViewModel(repository: repository,
                                          coordinator: coordinator,
                                          uiModel: uiModel)

        return NewOrderViewController(viewModel: viewModel,
                                      outputDelegate: outputDelegate)
    }
}
