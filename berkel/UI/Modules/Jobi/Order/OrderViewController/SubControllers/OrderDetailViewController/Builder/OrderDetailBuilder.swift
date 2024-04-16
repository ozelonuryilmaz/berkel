//
//  OrderDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum OrderDetailBuilder {

    static func generate(with data: OrderDetailPassData,
                         coordinator: IOrderDetailCoordinator,
                         outputDelegate: OrderDetailViewControllerOutputDelegate?) -> OrderDetailViewController {

        let repository = OrderDetailRepository()
        let uiModel = OrderDetailUIModel(data: data)
        let viewModel = OrderDetailViewModel(repository: repository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return OrderDetailViewController(viewModel: viewModel,
                                         outputDelegate: outputDelegate)
    }
}
