//
//  JobiListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

enum JobiListBuilder {

    static func generate(coordinator: IJobiListCoordinator) -> JobiListViewController {

        let repository = JobiListRepository()
        let uiModel = JobiListUIModel()
        let viewModel = JobiListViewModel(repository: repository,
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)

        return JobiListViewController(viewModel: viewModel)
    }
}
