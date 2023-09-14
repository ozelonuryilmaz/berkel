//
//  AddBuyingItemViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class AddBuyingItemViewController: MainBaseViewController {
    
    override var navigationTitle: String? {
        return "Alım Oluştur"
    }
    
    override var isShowTabbar: Bool {
        return false
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IAddBuyingItemViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IAddBuyingItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AddBuyingItemViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeViewState()
        self.listenErrorState()
    }

    override func registerEvents() {

    }


    private func observeViewState() {


    }

    private func listenErrorState() {
        // observeErrorState(errorState: viewModel._errorState)
    }

    // MARK: Define Components
}

// MARK: Props
private extension AddBuyingItemViewController {

}
