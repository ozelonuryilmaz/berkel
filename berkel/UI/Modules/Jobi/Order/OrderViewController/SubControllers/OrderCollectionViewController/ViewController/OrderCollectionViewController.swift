//
//  OrderCollectionViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol OrderCollectionViewControllerOutputDelegate: AnyObject {

}

final class OrderCollectionViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Sipariş Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IOrderCollectionViewModel
    private weak var outputDelegate: OrderCollectionViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var lblCustomer: UILabel!
    @IBOutlet private weak var lblProduct: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var tfCount: PrimaryTextField!
    @IBOutlet private weak var tfKDV: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnProduct: UIButton!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IOrderCollectionViewModel,
         outputDelegate: OrderCollectionViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "OrderCollectionViewController", bundle: nil)
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

        btnProduct.onTap { [unowned self] _ in
            self.viewModel.presentJBCustomerPriceViewController()
        }

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveOrder()
        }
    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
        listenTextFieldsDidChange()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            case .setCustomerName(let name):
                self.lblCustomer.text = name

            case .setProductName(let name):
                self.lblProduct.text = name

            case .setPrice(let price):
                self.lblPrice.text = price

            case .disableButton:
                self.btnSave.isEnabled = false

            case .showSystemAlert(let title, let message):
                self.showSystemAlert(title: title, message: message)

            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.viewModel.dismiss()
        }
    }()
}


// MARK: Props
private extension OrderCollectionViewController {

    func listenTextFieldsDidChange() {
        tfCount.addListenDidChange { [unowned self] text in
            self.viewModel.setCount(text)
        }

        tfKDV.addListenDidChange { [unowned self] text in
            self.viewModel.setKDV(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
