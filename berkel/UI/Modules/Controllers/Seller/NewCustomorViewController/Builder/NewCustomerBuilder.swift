//
//  NewCustomerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit

enum NewCustomerBuilder {

    static func generate(with data: NewCustomerPassData,
                         coordinator: INewCustomerCoordinator,
                         outputDelegate: NewCustomerViewControllerOutputDelegate?) -> NewCustomerViewController {

        let repository = NewCustomerRepository()
        let uiModel = NewCustomerUIModel(data: data)
        let viewModel = NewCustomerViewModel(repository: repository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return NewCustomerViewController(viewModel: viewModel,
                                         outputDelegate: outputDelegate)
    }
}
