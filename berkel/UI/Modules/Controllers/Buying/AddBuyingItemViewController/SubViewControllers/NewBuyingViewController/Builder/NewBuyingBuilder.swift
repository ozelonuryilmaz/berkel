//
//  NewBuyingBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

enum NewBuyingBuilder {

    static func generate(with data: NewBuyingPassData,
                         coordinator: INewBuyingCoordinator) -> NewBuyingViewController {

        let repository = NewBuyingRepository()
        let uiModel = NewBuyingUIModel(data: data)
        let viewModel = NewBuyingViewModel(repository: repository,
                                           coordinator: coordinator,
                                           uiModel: uiModel)

        return NewBuyingViewController(viewModel: viewModel)
    }
}
