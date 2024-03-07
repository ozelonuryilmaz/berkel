//
//  BuyingDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//

import UIKit

enum BuyingDetailBuilder {

    static func generate(with data: BuyingDetailPassData,
                         coordinator: IBuyingDetailCoordinator,
                         successDismissCallBack: ((_ isActive: Bool) -> Void)? = nil) -> BuyingDetailViewController {

        let repository = BuyingDetailRepository()
        let uiModel = BuyingDetailUIModel(data: data)
        let viewModel = BuyingDetailViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel,
                                              successDismissCallBack: successDismissCallBack)

        return BuyingDetailViewController(viewModel: viewModel)
    }
}
