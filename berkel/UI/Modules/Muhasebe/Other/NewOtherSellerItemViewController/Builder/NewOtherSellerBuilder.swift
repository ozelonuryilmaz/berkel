//
//  NewOtherSellerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

enum NewOtherSellerBuilder {

    static func generate(with data: NewOtherSellerPassData,
                         coordinator: INewOtherSellerCoordinator,
                         outputDelegate: NewOtherSellerViewControllerOutputDelegate?) -> NewOtherSellerViewController {

        let repository = NewOtherSellerRepository()
        let uiModel = NewOtherSellerUIModel(data: data)
        let viewModel = NewOtherSellerViewModel(repository: repository,
                                                coordinator: coordinator,
                                                uiModel: uiModel)

        return NewOtherSellerViewController(viewModel: viewModel,
                                            outputDelegate: outputDelegate)
    }
}
