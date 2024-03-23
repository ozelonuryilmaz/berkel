//
//  StockDetailInformationBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

enum StockDetailInformationBuilder {

    static func generate(with data: StockDetailInformationPassData,
                         coordinator: IStockDetailInformationCoordinator) -> StockDetailInformationViewController {

        let repository = StockDetailInformationRepository()
        let uiModel = StockDetailInformationUIModel(data: data)
        let viewModel = StockDetailInformationViewModel(repository: repository,
                                                        coordinator: coordinator,
                                                        uiModel: uiModel)

        return StockDetailInformationViewController(viewModel: viewModel)
    }
}
