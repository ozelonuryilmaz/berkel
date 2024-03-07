//
//  SellerCollectionBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

enum SellerCollectionBuilder {

    static func generate(with data: SellerCollectionPassData,
                         coordinator: ISellerCollectionCoordinator) -> SellerCollectionViewController {

        let repository = SellerCollectionRepository()
        let uiModel = SellerCollectionUIModel(data: data)
        let viewModel = SellerCollectionViewModel(repository: repository,
                                                  coordinator: coordinator,
                                                  uiModel: uiModel)

        return SellerCollectionViewController(viewModel: viewModel)
    }
}
