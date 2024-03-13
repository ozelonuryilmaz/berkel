//
//  EmptyAuthBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.03.2024.
//

import UIKit

enum EmptyAuthBuilder {

    static func generate(with data: EmptyAuthPassData,
                         coordinator: IEmptyAuthCoordinator) -> EmptyAuthViewController {

        let repository = EmptyAuthRepository()
        let uiModel = EmptyAuthUIModel(data: data)
        let viewModel = EmptyAuthViewModel(repository: repository,
                                           coordinator: coordinator,
                                           uiModel: uiModel)

        return EmptyAuthViewController(viewModel: viewModel)
    }
}
