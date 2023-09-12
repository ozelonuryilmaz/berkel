//
//  RegisterViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IRegisterViewModel: AnyObject {

    init(repository: IRegisterRepository,
         authRepository: AuthenticationRepository,
         coordinator: IRegisterCoordinator,
         uiModel: IRegisterUIModel)
}

final class RegisterViewModel: BaseViewModel, IRegisterViewModel {

    // MARK: Definitions
    private let repository: IRegisterRepository
    private let authRepository: AuthenticationRepository
    private let coordinator: IRegisterCoordinator
    private var uiModel: IRegisterUIModel

    // MARK: Initiliazer
    required init(repository: IRegisterRepository,
                  authRepository: AuthenticationRepository,
                  coordinator: IRegisterCoordinator,
                  uiModel: IRegisterUIModel) {
        self.repository = repository
        self.authRepository = authRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension RegisterViewModel {

}

// MARK: States
internal extension RegisterViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension RegisterViewModel {

}


enum RegisterViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum RegisterActionState {

}


