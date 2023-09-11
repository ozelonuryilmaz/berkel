//
//  LoginViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol ILoginViewModel: AnyObject {

    init(repository: ILoginRepository,
         authRepository: AuthenticationRepository,
         coordinator: ILoginCoordinator,
         uiModel: ILoginUIModel)
}

final class LoginViewModel: BaseViewModel, ILoginViewModel {

    // MARK: Definitions
    private let repository: ILoginRepository
    private let authRepository: AuthenticationRepository
    private let coordinator: ILoginCoordinator
    private var uiModel: ILoginUIModel

    // MARK: Initiliazer
    required init(repository: ILoginRepository,
                  authRepository: AuthenticationRepository,
                  coordinator: ILoginCoordinator,
                  uiModel: ILoginUIModel) {
        self.repository = repository
        self.authRepository = authRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension LoginViewModel {

}

// MARK: States
internal extension LoginViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension LoginViewModel {

}


enum LoginViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum LoginActionState {

}


