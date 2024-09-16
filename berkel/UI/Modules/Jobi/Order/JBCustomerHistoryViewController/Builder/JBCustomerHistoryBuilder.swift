//
//  JBCustomerHistoryBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum JBCustomerHistoryBuilder {

    static func generate(with data: JBCustomerHistoryPassData,
                         coordinator: IJBCustomerHistoryCoordinator) -> JBCustomerHistoryViewController {

        let repository = JBCustomerHistoryRepository()
        let uiModel = JBCustomerHistoryUIModel(data: data)
        let viewModel = JBCustomerHistoryViewModel(repository: repository,
                                                   coordinator: coordinator,
                                                   uiModel: uiModel)

        return JBCustomerHistoryViewController(viewModel: viewModel)
    }
}
