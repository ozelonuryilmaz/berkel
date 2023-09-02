//
//  SellerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
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
