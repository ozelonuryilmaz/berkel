//
//  OtherCollectionBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import UIKit

enum OtherCollectionBuilder {

    static func generate(with data: OtherCollectionPassData,
                         coordinator: IOtherCollectionCoordinator) -> OtherCollectionViewController {

        let repository = OtherCollectionRepository()
        let uiModel = OtherCollectionUIModel(data: data)
        let viewModel = OtherCollectionViewModel(repository: repository,
                                                 coordinator: coordinator,
                                                 uiModel: uiModel)

        return OtherCollectionViewController(viewModel: viewModel)
    }
}
