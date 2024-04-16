//
//  JBCustomerListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum JBCustomerListBuilder {

    static func generate(with data: JBCustomerListPassData,
                         coordinator: IJBCustomerListCoordinator,
                         outputDelegate: JBCustomerListViewControllerOutputDelegate?) -> JBCustomerListViewController {

        let repository = JBCustomerListRepository()
        let uiModel = JBCustomerListUIModel(data: data)
        let viewModel = JBCustomerListViewModel(repository: repository,
                                                coordinator: coordinator,
                                                uiModel: uiModel)

        return JBCustomerListViewController(viewModel: viewModel,
                                            outputDelegate: outputDelegate)
    }
}
