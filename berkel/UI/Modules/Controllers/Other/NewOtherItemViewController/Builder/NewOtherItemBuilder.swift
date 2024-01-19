//
//  NewOtherItemBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

enum NewOtherItemBuilder {

    static func generate(with data: NewOtherItemPassData,
                         coordinator: INewOtherItemCoordinator,
                         outputDelegate: NewOtherItemViewControllerOutputDelegate?) -> NewOtherItemViewController {

        let repository = NewOtherItemRepository()
        let uiModel = NewOtherItemUIModel(data: data)
        let viewModel = NewOtherItemViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return NewOtherItemViewController(viewModel: viewModel,
                                          outputDelegate: outputDelegate)
    }
}
