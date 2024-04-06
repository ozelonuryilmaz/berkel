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
        let jobiStockRepository = JobiStockRepository()
        let uiModel = StockUIModel()
        let viewModel = StockViewModel(repository: repository,
                                       jobiStockRepository: jobiStockRepository,
                                       coordinator: coordinator,
                                       uiModel: uiModel)

        return StockViewController(viewModel: viewModel)
    }
}
