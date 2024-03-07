//
//  ModuleSelectionBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

enum ModuleSelectionBuilder {

    static func generate(with data: ModuleSelectionPassData,
                         coordinator: IModuleSelectionCoordinator) -> ModuleSelectionViewController {

        let repository = ModuleSelectionRepository()
        let uiModel = ModuleSelectionUIModel(data: data)
        let viewModel = ModuleSelectionViewModel(repository: repository,
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)

        return ModuleSelectionViewController(viewModel: viewModel)
    }
}
