//
//  SellerPaymentBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

enum SellerPaymentBuilder {

    static func generate(with data: SellerPaymentPassData,
                         coordinator: ISellerPaymentCoordinator) -> SellerPaymentViewController {

        let repository = SellerPaymentRepository()
        let uiModel = SellerPaymentUIModel(data: data)
        let viewModel = SellerPaymentViewModel(repository: repository,
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)

        return SellerPaymentViewController(viewModel: viewModel)
    }
}
