//
//  BuyingChartsBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.01.2024.
//

import UIKit

enum BuyingChartsBuilder {

    static func generate(with data: BuyingChartsPassData,
                         coordinator: IBuyingChartsCoordinator) -> BuyingChartsViewController {

        let repository = BuyingChartsRepository()
        let uiModel = BuyingChartsUIModel(data: data)
        let viewModel = BuyingChartsViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return BuyingChartsViewController(viewModel: viewModel)
    }
}
