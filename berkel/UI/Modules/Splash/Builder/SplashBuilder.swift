//
//  SplashBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
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
