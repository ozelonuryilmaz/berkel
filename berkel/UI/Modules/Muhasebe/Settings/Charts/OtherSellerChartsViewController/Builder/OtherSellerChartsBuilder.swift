//
//  OtherSellerChartsBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import UIKit

enum OtherSellerChartsBuilder {

    static func generate(with data: OtherSellerChartsPassData,
                         coordinator: IOtherSellerChartsCoordinator) -> OtherSellerChartsViewController {

        let repository = OtherSellerChartsRepository()
        let uiModel = OtherSellerChartsUIModel(data: data)
        let viewModel = OtherSellerChartsViewModel(repository: repository,
                                                   coordinator: coordinator,
                                                   uiModel: uiModel)

        return OtherSellerChartsViewController(viewModel: viewModel)
    }
}
