//
//  ArchiveListBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

enum ArchiveListBuilder {

    static func generate(with data: ArchiveListPassData,
                         coordinator: IArchiveListCoordinator) -> ArchiveListViewController {

        let repository = ArchiveListRepository()
        let uiModel = ArchiveListUIModel(data: data)
        let viewModel = ArchiveListViewModel(repository: repository,
                                             coordinator: coordinator,
                                             uiModel: uiModel)

        return ArchiveListViewController(viewModel: viewModel)
    }
}
