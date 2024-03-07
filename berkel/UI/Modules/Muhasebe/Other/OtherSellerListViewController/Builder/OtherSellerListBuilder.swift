//
//  OtherSellerListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

enum OtherSellerListBuilder {

    static func generate(with data: OtherSellerListPassData,
                         coordinator: IOtherSellerListCoordinator,
                         outputDelegate: NewOtherItemViewControllerOutputDelegate?) -> OtherSellerListViewController {

        let repository = OtherSellerListRepository()
        let uiModel = OtherSellerListUIModel(data: data)
        let viewModel = OtherSellerListViewModel(repository: repository,
                                                 coordinator: coordinator,
                                                 uiModel: uiModel)

        return OtherSellerListViewController(viewModel: viewModel,
                                             outputDelegate: outputDelegate)
    }
}
