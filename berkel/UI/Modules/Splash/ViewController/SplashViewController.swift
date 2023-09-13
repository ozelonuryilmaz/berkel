//
//  SplashViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class SplashViewController: BerkelBaseViewController {

    // MARK: Inject
    private let viewModel: ISplashViewModel

    // MARK: Initializer
    init(viewModel: ISplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeViewState()

        self.viewModel.startFlowMainAfterLogin()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .startFlowMain:
                self.appDelegate.startFlowMain()
            }

        }).store(in: &cancelBag)
    }

}
