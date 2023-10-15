//
//  BuyingPaymentViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit
import Combine

final class BuyingPaymentViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Ödeme"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IBuyingPaymentViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblSellerName: UILabel!
    @IBOutlet private weak var lblProductName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var tfPayment: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!

    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IBuyingPaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingPaymentViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
    }

    override func setupView() {
        self.viewModel.initComponents()
        self.initDatePickerView()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.savePayment()
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

            case .setSellerAndProductName(let seller, let product):
                self.lblSellerName.text = seller
                self.lblProductName.text = "(\(product))"
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
private extension BuyingPaymentViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }

}

// MARK: TextField
private extension BuyingPaymentViewController {

    func listenTextFieldsDidChange() {
        tfPayment.addListenDidChange { [unowned self] text in
            self.viewModel.setPayment(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
