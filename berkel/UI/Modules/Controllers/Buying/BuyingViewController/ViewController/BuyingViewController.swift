//
//  BuyingViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class BuyingViewController: MainBaseViewController {
    
    override var navigationTitle: String? {
        return "Alım"
    }

    override var navigationSubTitle: String? {
        return UserDefaultsManager.shared.getStringValue(key: .season)
    }

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
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]

    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        observeActionState()
        listenErrorState()
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
        let errorHandle = FirestoreErrorHandle(
            viewController: self,
            callbackOverrideAlert: nil,
            callbackAlertButtonAction: {
                print("Tıklandı")
            }
        )
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.viewModel.pushAddBuyinItemViewController()
        }
    }()
}

// MARK: Props
private extension BuyingViewController {

}
