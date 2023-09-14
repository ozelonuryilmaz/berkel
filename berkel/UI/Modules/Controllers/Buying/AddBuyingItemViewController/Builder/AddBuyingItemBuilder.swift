//
//  AddBuyingItemBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

enum AddBuyingItemBuilder {

    static func generate(with data: AddBuyingItemPassData,
                         coordinator: IAddBuyingItemCoordinator) -> AddBuyingItemViewController {

        let repository = AddBuyingItemRepository()
        let uiModel = AddBuyingItemUIModel(data: data)
        let viewModel = AddBuyingItemViewModel(repository: repository,
                                               coordinator: coordinator,
                                               uiModel: uiModel)

        return AddBuyingItemViewController(viewModel: viewModel)
    }
}
