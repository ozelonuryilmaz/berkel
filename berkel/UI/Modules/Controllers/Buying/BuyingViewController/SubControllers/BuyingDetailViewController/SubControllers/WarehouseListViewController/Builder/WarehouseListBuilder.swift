//
//  WarehouseListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import UIKit

enum WarehouseListBuilder {

    static func generate(with data: WarehouseListPassData,
                         coordinator: IWarehouseListCoordinator,
                         successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil) -> WarehouseListViewController {

        let repository = WarehouseListRepository()
        let uiModel = WarehouseListUIModel(data: data)
        let viewModel = WarehouseListViewModel(repository: repository,
                                               coordinator: coordinator,
                                               uiModel: uiModel,
                                               successDismissCallBack: successDismissCallBack)

        return WarehouseListViewController(viewModel: viewModel)
    }
}
