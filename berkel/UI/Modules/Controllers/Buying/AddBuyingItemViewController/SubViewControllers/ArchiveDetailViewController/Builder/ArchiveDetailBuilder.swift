//
//  ArchiveDetailBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

enum ArchiveDetailBuilder {

    static func generate(with data: ArchiveDetailPassData,
                         coordinator: IArchiveDetailCoordinator) -> ArchiveDetailViewController {

        let repository = ArchiveDetailRepository()
        let uiModel = ArchiveDetailUIModel(data: data)
        let viewModel = ArchiveDetailViewModel(repository: repository,
                                               coordinator: coordinator,
                                               uiModel: uiModel)

        return ArchiveDetailViewController(viewModel: viewModel)
    }
}
