//
//  BuyingCollectionBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//

import UIKit

enum BuyingCollectionBuilder {

    static func generate(with data: BuyingCollectionPassData,
                         coordinator: IBuyingCollectionCoordinator,
                         successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)? = nil) -> BuyingCollectionViewController {

        let repository = BuyingCollectionRepository()
        let uiModel = BuyingCollectionUIModel(data: data)
        let viewModel = BuyingCollectionViewModel(repository: repository,
                                                  coordinator: coordinator,
                                                  uiModel: uiModel,
                                                  successDismissCallBack: successDismissCallBack)

        return BuyingCollectionViewController(viewModel: viewModel)
    }
}
