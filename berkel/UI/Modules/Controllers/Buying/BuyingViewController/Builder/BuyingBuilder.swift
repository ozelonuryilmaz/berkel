//
//  BuyingBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
// 

import UIKit

enum BuyingBuilder {
    
    static func generate(coordinator: IBuyingCoordinator) -> BuyingViewController {
        let repository = BuyingRepository()
        let uiModel = BuyingUIModel()
        let viewModel = BuyingViewModel(repository: repository, 
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)
        return BuyingViewController(viewModel: viewModel)
    }
}
