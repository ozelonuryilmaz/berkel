//
//  RegisterViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IRegisterViewModel: AnyObject {

    var viewState: ScreenStateSubject<RegisterViewState> { get }

    init(repository: IRegisterRepository,
         authRepository: AuthenticationRepository,
         coordinator: IRegisterCoordinator,
         uiModel: IRegisterUIModel,
         authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?)

    func setName(_ name: String)
    func setEmail(_ email: String)
    func setPassword(_ password: String)
    func setRePassword(_ rePassword: String)

    // Props
    func registerBeforeControl()

    // Coordinate
    func popToRootViewController(animated: Bool)
}

final class RegisterViewModel: BaseViewModel, IRegisterViewModel {

    // MARK: Definitions
    private let repository: IRegisterRepository
    private let authRepository: AuthenticationRepository
    private let coordinator: IRegisterCoordinator
    private var uiModel: IRegisterUIModel

    var viewState = ScreenStateSubject<RegisterViewState>(nil)

    var authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)? = nil

    // MARK: Initiliazer
    required init(repository: IRegisterRepository,
                  authRepository: AuthenticationRepository,
                  coordinator: IRegisterCoordinator,
                  uiModel: IRegisterUIModel,
                  authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) {
        self.repository = repository
        self.authRepository = authRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.authDismissCallBack = authDismissCallBack
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

    private func register() {
        self.authRepository.register(
            name: self.uiModel.name,
            email: self.uiModel.email,
            password: self.uiModel.password,
            completionLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            completionError: { [weak self] errorMessage in
                guard let self = self else { return }
                self.viewStateShowSystemAlert(message: errorMessage)
            },
            completionSuccess: { [weak self] in
                guard let self = self else { return }
                self.popToRootViewController(animated: false)
                self.authDismissCallBack?(true)
            })
    }
}

// MARK: Props
internal extension RegisterViewModel {

    func registerBeforeControl() {
        if self.uiModel.name.isEmpty || self.uiModel.email.isEmpty {
            self.viewStateShowSystemAlert(message: "Lütfen boş alan bırakmayınız")
            return
        }

        if self.uiModel.password.isEmpty || self.uiModel.rePassword.isEmpty {
            self.viewStateShowSystemAlert(message: "Lütfen parola giriniz")
            return
        }

        if self.uiModel.password != self.uiModel.rePassword {
            self.viewStateShowSystemAlert(message: "Girdiğiniz şifreler eşleşmiyor")
            return
        }

        self.register()
    }

}

// MARK: States
internal extension RegisterViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateShowSystemAlert(message: String) {
        viewState.value = .showSystemAlert(message: message)
    }
}

// MARK: Coordinate
internal extension RegisterViewModel {

    func popToRootViewController(animated: Bool) {
        self.coordinator.popToRootViewController(animated: animated)
    }
}


enum RegisterViewState {
    case showNativeProgress(isProgress: Bool)
    case showSystemAlert(message: String)
}
