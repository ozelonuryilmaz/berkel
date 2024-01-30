//
//  SellerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

enum SellerBuilder {

    static func generate(coordinator: ISellerCoordinator) -> SellerViewController {
        let repository = SellerRepository()
        let uiModel = SellerUIModel()
        let viewModel = SellerViewModel(repository: repository,
                                        coordinator: coordinator,
                                        uiModel: uiModel)
        return SellerViewController(viewModel: viewModel)
    }
}
