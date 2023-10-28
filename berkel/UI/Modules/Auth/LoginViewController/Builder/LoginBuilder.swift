//
//  LoginBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import UIKit

enum LoginBuilder {

    static func generate(with data: LoginPassData,
                         coordinator: ILoginCoordinator,
                         willDismissCallback: DefaultDismissCallback?,
                         didDismissCallback: DefaultDismissCallback?,
                         authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)? = nil) -> LoginViewController {

        let authRepository = AuthenticationRepository()

        let repository = LoginRepository()
        let uiModel = LoginUIModel(data: data)
        let viewModel = LoginViewModel(repository: repository,
                                       authRepository: authRepository,
                                       coordinator: coordinator,
                                       uiModel: uiModel)

        return LoginViewController(viewModel: viewModel,
                                   willDismissCallback: willDismissCallback,
                                   didDismissCallback: didDismissCallback,
                                   authDismissCallBack: authDismissCallBack)
    }
}
