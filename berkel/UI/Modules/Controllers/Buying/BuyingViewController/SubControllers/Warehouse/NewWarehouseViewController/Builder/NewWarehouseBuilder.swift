//
//  NewWarehouseBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import UIKit

enum NewWarehouseBuilder {

    static func generate(with data: NewWarehousePassData,
                         coordinator: INewWarehouseCoordinator,
                         successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil) -> NewWarehouseViewController {

        let repository = NewWarehouseRepository()
        let uiModel = NewWarehouseUIModel(data: data)
        let viewModel = NewWarehouseViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel,
                                              successDismissCallBack: successDismissCallBack)
        return NewWarehouseViewController(viewModel: viewModel)
    }
}
