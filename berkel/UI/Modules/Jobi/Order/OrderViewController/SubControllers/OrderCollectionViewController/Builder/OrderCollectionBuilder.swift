//
//  OrderCollectionBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum OrderCollectionBuilder {

    static func generate(with data: OrderCollectionPassData,
                         coordinator: IOrderCollectionCoordinator,
                         outputDelegate: OrderCollectionViewControllerOutputDelegate?) -> OrderCollectionViewController {

        let repository = OrderCollectionRepository()
        let uiModel = OrderCollectionUIModel(data: data)
        let viewModel = OrderCollectionViewModel(repository: repository,
                                                 coordinator: coordinator,
                                                 uiModel: uiModel)

        return OrderCollectionViewController(viewModel: viewModel,
                                             outputDelegate: outputDelegate)
    }
}
