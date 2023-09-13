//
//  LoginViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class LoginViewController: BerkelBaseViewController {

    // MARK: Constants

    var authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)? = nil

    // MARK: Inject
    private let viewModel: ILoginViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tfEmail: PrimaryTextField!
    @IBOutlet private weak var tfPassword: PrimaryTextField!
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var btnRegister: UIButton!
    @IBOutlet private weak var btnForgotPassword: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ILoginViewModel,
         willDismissCallback: DefaultDismissCallback? = nil,
         didDismissCallback: DefaultDismissCallback? = nil,
         authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)

        self.willDismissCallback = willDismissCallback
        self.didDismissCallback = didDismissCallback
        self.authDismissCallBack = authDismissCallBack
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
    }

    override func registerEvents() {
        listenEmailTextFieldDidChange()
        listenPasswordTextFieldDidChange()

        btnLogin.onTap { [unowned self] _ in
            self.viewModel.loginBeforeControl()
        }

        btnRegister.onTap { [unowned self] _ in
            self.viewModel.pushRegisterViewController()
        }

        btnForgotPassword.onTap { [unowned self] _ in
            self.viewModel.forgotPasswordBeforeControl()
        }
    }

    private func observeReactiveDatas() {
        observeViewState()
        observeActionState()
        // listenErrorState()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showSystemAlert(let message):
                self.showSystemAlert(title: message, message: "")

            case .loggedIn(let isLoggedIn):
                self.authDismissCallBack?(isLoggedIn)
            }

        }).store(in: &cancelBag)
    }

    private func observeActionState() {
        /* viewModel._actionState.observeNext { [unowned self] state in
             switch state {
            
            } 
        }.dispose(in: disposeBag) */
    }

    private func listenErrorState() {
        // observeErrorState(errorState: viewModel._errorState)
    }

}

// MARK: Props
private extension LoginViewController {

}

// MARK: TextField
private extension LoginViewController {

    func listenEmailTextFieldDidChange() {
        tfEmail.addListenDidChange { [unowned self] text in
            self.viewModel.setEmail(text)
        }
    }

    func listenPasswordTextFieldDidChange() {
        tfPassword.addListenDidChange { [unowned self] text in
            self.viewModel.setPassword(text)
        }
    }
}
