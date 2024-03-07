//
//  SellerChartsBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.12.2023.
//

import UIKit

enum SellerChartsBuilder {

    static func generate(with data: SellerChartsPassData,
                         coordinator: ISellerChartsCoordinator) -> SellerChartsViewController {

        let repository = SellerChartsRepository()
        let uiModel = SellerChartsUIModel(data: data)
        let viewModel = SellerChartsViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return SellerChartsViewController(viewModel: viewModel)
    }
}
