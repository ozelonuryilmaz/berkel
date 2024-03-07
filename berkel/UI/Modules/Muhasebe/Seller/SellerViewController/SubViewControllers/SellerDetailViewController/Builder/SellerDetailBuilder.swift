//
//  SellerDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

enum SellerDetailBuilder {

    static func generate(with data: SellerDetailPassData,
                         coordinator: ISellerDetailCoordinator,
                         outputDelegate: SellerDetailViewControllerOutputDelegate?) -> SellerDetailViewController {

        let repository = SellerDetailRepository()
        let uiModel = SellerDetailUIModel(data: data)
        let viewModel = SellerDetailViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return SellerDetailViewController(viewModel: viewModel,
                                          outputDelegate: outputDelegate)
    }
}
