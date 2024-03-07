//
//  NewBuyingBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//

import UIKit

enum NewBuyingBuilder {

    static func generate(with data: NewBuyingPassData,
                         coordinator: INewBuyingCoordinator,
                         successDismissCallBack: ((_ data: NewBuyingModel) -> Void)? = nil) -> NewBuyingViewController {

        let repository = NewBuyingRepository()
        let uiModel = NewBuyingUIModel(data: data)
        let viewModel = NewBuyingViewModel(repository: repository,
                                           coordinator: coordinator,
                                           uiModel: uiModel,
                                           successDismissCallBack: successDismissCallBack)

        return NewBuyingViewController(viewModel: viewModel)
    }
}
