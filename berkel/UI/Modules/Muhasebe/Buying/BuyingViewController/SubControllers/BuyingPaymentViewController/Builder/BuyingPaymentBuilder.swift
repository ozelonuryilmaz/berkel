//
//  BuyingPaymentBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//

import UIKit

enum BuyingPaymentBuilder {

    static func generate(with data: BuyingPaymentPassData,
                         coordinator: IBuyingPaymentCoordinator) -> BuyingPaymentViewController {

        let repository = BuyingPaymentRepository()
        let uiModel = BuyingPaymentUIModel(data: data)
        let viewModel = BuyingPaymentViewModel(repository: repository,
                                               coordinator: coordinator,
                                               uiModel: uiModel)

        return BuyingPaymentViewController(viewModel: viewModel)
    }
}
