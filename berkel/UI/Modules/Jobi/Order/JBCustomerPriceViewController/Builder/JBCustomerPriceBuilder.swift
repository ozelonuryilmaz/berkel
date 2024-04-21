//
//  JBCustomerPriceBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum JBCustomerPriceBuilder {

    static func generate(with data: JBCustomerPricePassData,
                         coordinator: IJBCustomerPriceCoordinator,
                         outputDelegate: JBCustomerPriceViewControllerOutputDelegate?) -> JBCustomerPriceViewController {

        let repository = JBCustomerPriceRepository()
        let jobiStockRepository = JobiStockRepository()
        let uiModel = JBCustomerPriceUIModel(data: data)
        let viewModel = JBCustomerPriceViewModel(repository: repository, 
                                                 jobiStockRepository: jobiStockRepository,
                                                 coordinator: coordinator,
                                                 uiModel: uiModel)

        return JBCustomerPriceViewController(viewModel: viewModel,
                                             outputDelegate: outputDelegate)
    }
}
