//
//  OtherPaymentBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit

enum OtherPaymentBuilder {

    static func generate(with data: OtherPaymentPassData,
                         coordinator: IOtherPaymentCoordinator) -> OtherPaymentViewController {

        let repository = OtherPaymentRepository()
        let uiModel = OtherPaymentUIModel(data: data)
        let viewModel = OtherPaymentViewModel(repository: repository,
                                              coordinator: coordinator,
                                              uiModel: uiModel)

        return OtherPaymentViewController(viewModel: viewModel)
    }
}
