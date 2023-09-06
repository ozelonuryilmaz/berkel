//
//  BuyingViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class BuyingViewController: MainBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IBuyingViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IBuyingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()

        viewModel.getDocuments()
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        observeActionState()
    }

    private func observeViewState() {

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
private extension BuyingViewController {

}
