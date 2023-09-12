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

    func setName(_ name: String)
    func setEmail(_ email: String)
    func setPassword(_ password: String)
    func setRePassword(_ rePassword: String)

    // Service
    func register()

    // Coordinate
    func popToRootViewController()
}

final class RegisterViewModel: BaseViewModel, IRegisterViewModel {

    // MARK: Definitions
    private let repository: IRegisterRepository
    private let authRepository: AuthenticationRepository
    private let coordinator: IRegisterCoordinator
    private var uiModel: IRegisterUIModel

    var saveUserErrorState = ErrorStateSubject(nil)

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

    func setName(_ name: String) {
        self.uiModel.setName(name)
    }

    func setEmail(_ email: String) {
        self.uiModel.setEmail(email)
    }

    func setPassword(_ password: String) {
        self.uiModel.setPassword(password)
    }

    func setRePassword(_ rePassword: String) {
        self.uiModel.setRePassword(rePassword)
    }
}


// MARK: Service
internal extension RegisterViewModel {

    func register() {
        print("\(uiModel.name), \(uiModel.email), \(uiModel.password), \(uiModel.rePassword)")

        let request = self.authRepository.saveUser(id: "ididid", data: SaveUserInput(name: "onur2", email: "mail"))
        handleResourceSetDataState(
            request: request,
            errorState: saveUserErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                print("******  Kaydedildi")
            })
    }
}

// MARK: States
internal extension RegisterViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension RegisterViewModel {

    func popToRootViewController() {
        self.coordinator.popToRootViewController()
    }
}


enum RegisterViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum RegisterActionState {

}


