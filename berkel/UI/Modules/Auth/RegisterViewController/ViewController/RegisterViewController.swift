//
//  RegisterViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//

import UIKit

final class RegisterViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Kayıt Olun"
    }

    // MARK: Inject
    private let viewModel: IRegisterViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tfName: PrimaryTextField!
    @IBOutlet private weak var tfEmail: PrimaryTextField!
    @IBOutlet private weak var tfPassword: PrimaryTextField!
    @IBOutlet private weak var tfRePassword: PrimaryTextField!
    @IBOutlet private weak var btnRegister: UIButton!
    @IBOutlet private weak var btnLogin: UIButton!

    // MARK: Initializer
    init(viewModel: IRegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "RegisterViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeViewState()
        self.listenErrorState()
    }

    override func registerEvents() {
        listenNameTextFieldDidChange()
        listenEmailTextFieldDidChange()
        listenPasswordTextFieldDidChange()
        listenRePasswordTextFieldDidChange()

        btnLogin.onTap { [unowned self] _ in
            self.viewModel.popToRootViewController(animated: true)
        }

        btnRegister.onTap { [unowned self] _ in
            self.viewModel.registerBeforeControl()
        }
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            case .showSystemAlert(let message):
                self.showSystemAlert(title: message, message: "")
            }

        }).store(in: &cancelBag)
    }
    
    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }
}

// MARK: TextField
private extension RegisterViewController {

    func listenNameTextFieldDidChange() {
        tfName.addListenDidChange { [unowned self] text in
            self.viewModel.setName(text)
        }
    }

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

    func listenRePasswordTextFieldDidChange() {
        tfRePassword.addListenDidChange { [unowned self] text in
            self.viewModel.setRePassword(text)
        }
    }
}
