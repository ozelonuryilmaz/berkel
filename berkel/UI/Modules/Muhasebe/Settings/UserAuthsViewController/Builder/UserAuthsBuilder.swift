//
//  UserAuthsBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import UIKit

enum UserAuthsBuilder {

    static func generate(with data: UserAuthsPassData,
                         coordinator: IUserAuthsCoordinator) -> UserAuthsViewController {

        let repository = UserAuthsRepository()
        let uiModel = UserAuthsUIModel(data: data)
        let viewModel = UserAuthsViewModel(repository: repository,
                                           coordinator: coordinator,
                                           uiModel: uiModel)

        return UserAuthsViewController(viewModel: viewModel)
    }
}
