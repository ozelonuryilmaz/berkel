//
//  OrderPaymentBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum OrderPaymentBuilder {

    static func generate(with data: OrderPaymentPassData,
                         coordinator: IOrderPaymentCoordinator,
                         outputDelegate: OrderPaymentViewControllerOutputDelegate?) -> OrderPaymentViewController {

        let repository = OrderPaymentRepository()
        let uiModel = OrderPaymentUIModel(data: data)
        let viewModel = OrderPaymentViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return OrderPaymentViewController(viewModel: viewModel,
                                          outputDelegate: outputDelegate)
    }
}
