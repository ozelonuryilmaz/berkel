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

    // MARK: Inject
    private let viewModel: ILoginViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: ILoginViewModel,
         willDismissCallback: DefaultDismissCallback? = nil,
         didDismissCallback: DefaultDismissCallback? = nil) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)
        
        self.willDismissCallback = willDismissCallback
        self.didDismissCallback = didDismissCallback
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
    }

    override func registerEvents() {

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
