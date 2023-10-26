//
//  NewWarehouseViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit
import Combine

final class NewWarehouseViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewWarehouseViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblSellerName: UILabel!
    @IBOutlet private weak var lblProductName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var tfKg: PrimaryTextField!
    @IBOutlet private weak var tfPrice: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!

    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewWarehouseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "NewWarehouseViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewStateSetNavigationTitle()
    }

    override func setupView() {
        self.viewModel.initComponents()
        self.initDatePickerView()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveWarehouse()
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

            case .setNavigationTitle(let title, let subTitle):
                self.navigationItem.setCustomTitle(title, subtitle: subTitle)

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
}

// MARK: Props
private extension NewWarehouseViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}

// MARK: TextField
private extension NewWarehouseViewController {

    func listenTextFieldsDidChange() {
        tfKg.addListenDidChange { [unowned self] text in
            self.viewModel.setKg(text)
        }

        tfPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setPrice(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
