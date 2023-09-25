//
//  NewBuyingViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class NewBuyingViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Yeni Alım Oluştur"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewBuyingViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblSellerName: UILabel!
    @IBOutlet private weak var lblSellerTCKN: UILabel!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewBuyingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "NewBuyingViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]

        self.observeReactiveDatas()
        self.viewModel.initComponents()
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .setSellerName(let name):
                self.lblSellerName.text = name
            case .setSellerTCKN(let tckn):
                self.lblSellerTCKN.text = tckn
            }

        }).store(in: &cancelBag)
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
private extension NewBuyingViewController {

}
