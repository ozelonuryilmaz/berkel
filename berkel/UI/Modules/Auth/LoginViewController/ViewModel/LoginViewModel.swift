//
//  LoginViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol ILoginViewModel: AnyObject {

    var viewState: ScreenStateSubject<LoginViewState> { get }

    init(repository: ILoginRepository,
         authRepository: AuthenticationRepository,
         coordinator: ILoginCoordinator,
         uiModel: ILoginUIModel)

    func setEmail(_ email: String)
    func setPassword(_ password: String)

    func loginBeforeControl()
    func forgotPasswordBeforeControl()

    // Coordinate
    func pushRegisterViewController()
    func dismiss(completion: (() -> Void)?)
}

final class LoginViewModel: BaseViewModel, ILoginViewModel {

    // MARK: Definitions
    private let repository: ILoginRepository
    private let authRepository: AuthenticationRepository
    private let coordinator: ILoginCoordinator
    private var uiModel: ILoginUIModel

    var viewState = ScreenStateSubject<LoginViewState>(nil)

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

    func setEmail(_ email: String) {
        self.uiModel.setEmail(email)
    }

    func setPassword(_ password: String) {
        self.uiModel.setPassword(password)
    }
}


// MARK: Service
internal extension LoginViewModel {

    private func login() {
        self.authRepository.login(
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
                self.dismiss(completion: {
                    self.viewStateLoggedIn(isLoggedIn: true)
                })
            })
    }

    private func forgotPassword() {
        self.authRepository.sendResetLink(
            email: self.uiModel.email,
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
                self.viewStateShowSystemAlert(message: "Şifre sıfırlama linki mail adresinize gönderildi.")
            })
    }
}

extension LoginViewModel {

    func loginBeforeControl() {
        if self.uiModel.email.isEmpty || self.uiModel.password.isEmpty {
            self.viewStateShowSystemAlert(message: "Bilgilerinizi kontrol ediniz")
            return
        }

        self.login()
    }

    func forgotPasswordBeforeControl() {
        if self.uiModel.email.isEmpty {
            self.viewStateShowSystemAlert(message: "Lütfen email alanını doldurunuz")
            return
        }

        self.forgotPassword()
    }
}

// MARK: States
internal extension LoginViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateShowSystemAlert(message: String) {
        viewState.value = .showSystemAlert(message: message)
    }

    func viewStateLoggedIn(isLoggedIn: Bool) {
        viewState.value = .loggedIn(isLoggedIn: isLoggedIn)
    }
}

// MARK: Coordinate
internal extension LoginViewModel {

    func pushRegisterViewController() {
        self.coordinator.pushRegisterViewController(authDismissCallBack: { [weak self] isLoggedIn in
            self?.dismiss(completion: {
                self?.viewStateLoggedIn(isLoggedIn: isLoggedIn)
            })
        })
    }

    func dismiss(completion: (() -> Void)?) {
        self.coordinator.dismiss(completion: completion)
    }
}


enum LoginViewState {
    case showNativeProgress(isProgress: Bool)
    case showSystemAlert(message: String)
    case loggedIn(isLoggedIn: Bool)
}
