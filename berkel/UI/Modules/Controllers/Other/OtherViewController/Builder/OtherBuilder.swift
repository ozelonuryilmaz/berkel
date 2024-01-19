//
//  OtherBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

enum OtherBuilder {

    static func generate(coordinator: IOtherCoordinator) -> OtherViewController {

        let repository = OtherRepository()
        let uiModel = OtherUIModel()
        let viewModel = OtherViewModel(repository: repository,
                                       coordinator: coordinator,
                                       uiModel: uiModel)

        return OtherViewController(viewModel: viewModel)
    }
}
