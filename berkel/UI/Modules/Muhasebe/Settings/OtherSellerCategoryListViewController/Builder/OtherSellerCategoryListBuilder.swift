//
//  OtherSellerCategoryListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

enum OtherSellerCategoryListBuilder {

    static func generate(with data: OtherSellerCategoryListPassData,
                         coordinator: IOtherSellerCategoryListCoordinator,
                         outputDelegate: OtherSellerCategoryListViewControllerOutputDelegate?) -> OtherSellerCategoryListViewController {

        let repository = OtherSellerCategoryListRepository()
        let uiModel = OtherSellerCategoryListUIModel(data: data)
        let viewModel = OtherSellerCategoryListViewModel(repository: repository,
                                                         coordinator: coordinator,
                                                         uiModel: uiModel)

        return OtherSellerCategoryListViewController(viewModel: viewModel,
                                                     outputDelegate: outputDelegate)
    }
}
