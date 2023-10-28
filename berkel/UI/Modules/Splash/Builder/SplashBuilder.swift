//
//  SplashBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

enum SplashBuilder {

    static func generate(coordinator: ISplashCoordinator) -> SplashViewController {

        let repository = SplashRepository()
        let uiModel = SplashUIModel()
        let viewModel = SplashViewModel(repository: repository,
                                        coordinator: coordinator,
                                        uiModel: uiModel)

        return SplashViewController(viewModel: viewModel)
    }
}
