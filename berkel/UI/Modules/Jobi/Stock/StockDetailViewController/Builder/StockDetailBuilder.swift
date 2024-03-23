//
//  StockDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

enum StockDetailBuilder {

    static func generate(with data: StockDetailPassData,
                         coordinator: IStockDetailCoordinator) -> StockDetailViewController {

        let repository = StockDetailRepository()
        let uiModel = StockDetailUIModel(data: data)
        let viewModel = StockDetailViewModel(repository: repository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return StockDetailViewController(viewModel: viewModel)
    }
}
