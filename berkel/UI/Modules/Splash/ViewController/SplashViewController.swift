//
//  SplashViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
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

        self.viewModel.getUsersForScreens()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            case .startFlowAccounting:
                self.appDelegate.startFlowAccounting()
                
            case .startFlowJobi:
                self.appDelegate.startFlowJobi()
                
            case .startModuleSelection:
                self.viewModel.presentModuleSelectionViewController()
                
            case .restartApp:
                self.appDelegate.startFlowSplash()
            }

        }).store(in: &cancelBag)
    }

}
