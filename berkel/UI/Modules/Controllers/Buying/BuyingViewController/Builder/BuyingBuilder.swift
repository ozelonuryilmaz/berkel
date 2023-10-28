//
//  BuyingBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
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
