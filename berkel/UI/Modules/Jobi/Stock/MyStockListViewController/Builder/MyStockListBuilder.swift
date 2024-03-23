//
//  MyStockListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

enum MyStockListBuilder {

    static func generate(with data: MyStockListPassData,
                         coordinator: IMyStockListCoordinator,
                         outputDelegate: MyStockListViewControllerOutputDelegate?) -> MyStockListViewController {

        let repository = MyStockListRepository()
        let jobiStockRepository = JobiStockRepository()
        let uiModel = MyStockListUIModel(data: data)
        let viewModel = MyStockListViewModel(repository: repository,
                                             jobiStockRepository: jobiStockRepository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return MyStockListViewController(viewModel: viewModel,
                                         outputDelegate: outputDelegate)
    }
}
