//
//  RegisterBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

enum RegisterBuilder {

    static func generate(with data: RegisterPassData,
                         coordinator: IRegisterCoordinator,
                         authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)? = nil) -> RegisterViewController {

        let authRepository = AuthenticationRepository()

        let repository = RegisterRepository()
        let uiModel = RegisterUIModel(data: data)
        let viewModel = RegisterViewModel(repository: repository,
                                          authRepository: authRepository,
                                          coordinator: coordinator,
                                          uiModel: uiModel,
                                          authDismissCallBack: authDismissCallBack)

        return RegisterViewController(viewModel: viewModel)
    }
}
