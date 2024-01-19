//
//  CustomerListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit

enum CustomerListBuilder {

    static func generate(with data: CustomerListPassData,
                         coordinator: ICustomerListCoordinator,
                         outputDelegate: NewSellerViewControllerOutputDelegate?) -> CustomerListViewController {

        let repository = CustomerListRepository()
        let uiModel = CustomerListUIModel(data: data)
        let viewModel = CustomerListViewModel(repository: repository,
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)

        return CustomerListViewController(viewModel: viewModel,
                                          outputDelegate: outputDelegate)
    }
}
