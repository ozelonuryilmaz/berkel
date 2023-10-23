//
//  NewSellerImageBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

enum NewSellerImageBuilder {

    static func generate(with data: NewSellerImagePassData,
                         coordinator: INewSellerImageCoordinator) -> NewSellerImageViewController {

        let repository = NewSellerImageRepository()
        let uiModel = NewSellerImageUIModel(data: data)
        let viewModel = NewSellerImageViewModel(repository: repository,
                                                coordinator: coordinator,
                                                uiModel: uiModel)
        return NewSellerImageViewController(viewModel: viewModel)
    }
}
