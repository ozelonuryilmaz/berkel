//
//  NewJBCustomerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

enum NewJBCustomerBuilder {

    static func generate(with data: NewJBCustomerPassData,
                         coordinator: INewJBCustomerCoordinator,
                         outputDelegate: NewJBCustomerViewControllerOutputDelegate?) -> NewJBCustomerViewController {

        let repository = NewJBCustomerRepository()
        let uiModel = NewJBCustomerUIModel(data: data)
        let viewModel = NewJBCustomerViewModel(repository: repository,
                                               coordinator: coordinator,
                                               uiModel: uiModel)

        return NewJBCustomerViewController(viewModel: viewModel,
                                           outputDelegate: outputDelegate)
    }
}
