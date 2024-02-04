//
//  OtherDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit

enum OtherDetailBuilder {

    static func generate(with data: OtherDetailPassData,
                         coordinator: IOtherDetailCoordinator,
                         outputDelegate: OtherDetailViewControllerOutputDelegate?) -> OtherDetailViewController {

        let repository = OtherDetailRepository()
        let uiModel = OtherDetailUIModel(data: data)
        let viewModel = OtherDetailViewModel(repository: repository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return OtherDetailViewController(viewModel: viewModel,
                                         outputDelegate: outputDelegate)
    }
}
