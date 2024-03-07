//
//  StockBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

enum StockBuilder {

    static func generate(coordinator: IStockCoordinator) -> StockViewController {

        let repository = StockRepository()
        let uiModel = StockUIModel()
        let viewModel = StockViewModel(repository: repository,
                                       coordinator: coordinator,
                                       uiModel: uiModel)

        return StockViewController(viewModel: viewModel)
    }
}
