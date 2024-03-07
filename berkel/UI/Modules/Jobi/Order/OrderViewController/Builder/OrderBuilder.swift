//
//  OrderBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

enum OrderBuilder {

    static func generate(coordinator: IOrderCoordinator) -> OrderViewController {

        let repository = OrderRepository()
        let uiModel = OrderUIModel()
        let viewModel = OrderViewModel(repository: repository,
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)

        return OrderViewController(viewModel: viewModel)
    }
}
