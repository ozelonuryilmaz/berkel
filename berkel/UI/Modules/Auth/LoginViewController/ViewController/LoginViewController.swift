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
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var btnRegister: UIButton!

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
        
        btnLogin.onTap { [unowned self] _ in
            self.viewModel.dismiss(completion: {
                self.authDismissCallBack?(true)
            })
        }

        btnRegister.onTap { [unowned self] _ in
            self.viewModel.pushRegisterViewController()
        }
    }

    private func observeReactiveDatas() {
        observeViewState()
        observeActionState()
        // listenErrorState()
    }

    private func observeViewState() {
        /*viewModel._viewState.observeNext { [unowned self] state in
            switch state {
            case .showLoadingProgress(let isProgress):
                self.playLottieLoading(isLoading: isProgress)
            }
        }.dispose(in: disposeBag)*/
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

    // MARK: Define Components (if you have or delete this line)
}

// MARK: Props
private extension LoginViewController {
    
}
