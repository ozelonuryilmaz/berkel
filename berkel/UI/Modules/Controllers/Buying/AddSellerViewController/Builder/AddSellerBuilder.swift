//
//  AddSellerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

enum AddSellerBuilder {

    static func generate(with data: AddSellerPassData,
                         coordinator: IAddSellerCoordinator,
                         outputDelegate: AddSellerViewControllerOutputDelegate?) -> AddSellerViewController {

        let repository = AddSellerRepository()
        let uiModel = AddSellerUIModel(data: data)
        let viewModel = AddSellerViewModel(repository: repository,
                                           coordinator: coordinator,
                                           uiModel: uiModel)

        return AddSellerViewController(viewModel: viewModel,
                                       outputDelegate: outputDelegate)
    }
}
