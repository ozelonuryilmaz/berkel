//
//  BuyingDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit
import Combine

final class BuyingDetailViewController: MainBaseViewController {
    
    override var isShowTabbar: Bool {
        return false
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IBuyingDetailViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IBuyingDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingDetailViewController", bundle: nil)
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
        listenErrorState()
    }

    private func observeViewState() {

    }

    private func listenErrorState() {

    }

    // MARK: Define Components
}

// MARK: Props
private extension BuyingDetailViewController {

}
