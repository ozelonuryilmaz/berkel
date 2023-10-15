//
//  BuyingDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

enum BuyingDetailBuilder {

    static func generate(with data: BuyingDetailPassData,
                         coordinator: IBuyingDetailCoordinator) -> BuyingDetailViewController {

        let repository = BuyingDetailRepository()
        let uiModel = BuyingDetailUIModel(data: data)
        let viewModel = BuyingDetailViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return BuyingDetailViewController(viewModel: viewModel)
    }
}
