//
//  ProductListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import UIKit

enum ProductListBuilder {

    static func generate(with data: ProductListPassData,
                         coordinator: IProductListCoordinator,
                         outputDelegate: ProductListViewControllerOutputDelegate?) -> ProductListViewController {

        let repository = ProductListRepository()
        let uiModel = ProductListUIModel(data: data)
        let viewModel = ProductListViewModel(repository: repository,
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)

        return ProductListViewController(viewModel: viewModel,
                                         outputDelegate: outputDelegate)
    }
}
