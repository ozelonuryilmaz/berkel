//
//  NewSellerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit

enum NewSellerBuilder {

    static func generate(with data: NewSellerPassData,
                         coordinator: INewSellerCoordinator,
                         outputDelegate: NewSellerViewControllerOutputDelegate?) -> NewSellerViewController {

        let repository = NewSellerRepository()
        let uiModel = NewSellerUIModel(data: data)
        let viewModel = NewSellerViewModel(repository: repository,
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)

        return NewSellerViewController(viewModel: viewModel,
                                       outputDelegate: outputDelegate)
    }
}
