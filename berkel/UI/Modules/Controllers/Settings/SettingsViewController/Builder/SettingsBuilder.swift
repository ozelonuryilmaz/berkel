//
//  SettingsBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

enum SettingsBuilder {

    static func generate(coordinator: ISettingsCoordinator) -> SettingsViewController {
        let repository = SettingsRepository()
        let uiModel = SettingsUIModel()
        let viewModel = SettingsViewModel(repository: repository,
                                          coordinator: coordinator,
                                          uiModel: uiModel)
        return SettingsViewController(viewModel: viewModel)
    }
}
