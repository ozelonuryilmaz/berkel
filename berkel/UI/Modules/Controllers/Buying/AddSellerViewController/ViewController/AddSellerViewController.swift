//
//  AddSellerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class AddSellerViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Satıcı Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IAddSellerViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IAddSellerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AddSellerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
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
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.viewModel.dismiss()
        }
    }()
}

// MARK: Props
private extension AddSellerViewController {

}
