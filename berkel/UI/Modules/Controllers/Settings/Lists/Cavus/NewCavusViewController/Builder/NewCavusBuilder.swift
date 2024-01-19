//
//  NewCavusBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

enum NewCavusBuilder {

    static func generate(with data: NewCavusPassData,
                         coordinator: INewCavusCoordinator,
                         outputDelegate: NewCavusViewControllerOutputDelegate?) -> NewCavusViewController {

        let repository = NewCavusRepository()
        let uiModel = NewCavusUIModel(data: data)
        let viewModel = NewCavusViewModel(repository: repository,
                                          coordinator: coordinator,
                                          uiModel: uiModel)

        return NewCavusViewController(viewModel: viewModel,
                                      outputDelegate: outputDelegate)
    }
}
