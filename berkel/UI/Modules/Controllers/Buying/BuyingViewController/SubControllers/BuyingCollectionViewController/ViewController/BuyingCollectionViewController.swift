//
//  BuyingCollectionViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class BuyingCollectionViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Toplama"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IBuyingCollectionViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblSellerName: UILabel!
    @IBOutlet private weak var lblProductName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var lblTotalKG: UILabel!
    @IBOutlet private weak var lblTotalPrice: UILabel!

    @IBOutlet private weak var btnSave: UIButton!

    @IBOutlet private weak var tfKantarFisi: PrimaryTextField!
    @IBOutlet private weak var tfPalet: PrimaryTextField!
    @IBOutlet private weak var tfRedCase: PrimaryTextField!
    @IBOutlet private weak var tfGreenCase: PrimaryTextField!
    @IBOutlet private weak var tf22BlackFoodCase: PrimaryTextField!
    @IBOutlet private weak var tfBigBlackCase: PrimaryTextField!
    @IBOutlet private weak var tfPercentFire: PrimaryTextField!
    @IBOutlet private weak var tfKgPrice: PrimaryTextField!
    @IBOutlet private weak var tfPaletDari: PrimaryTextField!
    @IBOutlet private weak var tfRedDari: PrimaryTextField!
    @IBOutlet private weak var tfGreenDari: PrimaryTextField!
    @IBOutlet private weak var tf22BlackDari: PrimaryTextField!
    @IBOutlet private weak var tfBigBlackDari: PrimaryTextField!


    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IBuyingCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingCollectionViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
    }

    override func setupView() {
        self.initDatePickerView()
        self.viewModel.initComponents()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveCollection()
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

            case .setSellerAndProductNameAndKg(let seller, let product, let kgPrice):
                self.lblSellerName.text = seller
                self.lblProductName.text = "(\(product))"
                self.tfKgPrice.placeholder = String(kgPrice)

            case .setTotalKg(let kg):
                self.lblTotalKG.text = kg + " Kg"

            case .setTotalPrice(let price):
                self.lblTotalPrice.text = price + " TL"


            case .getViewedPageData(let data):

                self.datePicker.date = data.date?.getApiResponseTypeDate() ?? Date()
                self.tfKantarFisi.textField.text = String(data.kantarFisi)
                self.tfPalet.textField.text = String(data.palet)
                self.tfRedCase.textField.text = String(data.redCase)
                self.tfGreenCase.textField.text = String(data.greenCase)
                self.tf22BlackFoodCase.textField.text = String(data.black22FoodCase)
                self.tfBigBlackCase.textField.text = String(data.bigBlackCase)
                self.tfPercentFire.textField.text = data.percentFire.decimalString()
                self.tfKgPrice.textField.text = String(data.kgPrice.decimalString())
                self.tfPaletDari.textField.text = data.paletDari.decimalString()
                self.tfRedDari.textField.text = data.redDari.decimalString()
                self.tfGreenDari.textField.text = data.greenDari.decimalString()
                self.tf22BlackDari.textField.text = data.black22FoodDari.decimalString()
                self.tfBigBlackDari.textField.text = data.bigBlackDari.decimalString()

                self.datePicker.isEnabled = false
                self.tfKantarFisi.textField.isEnabled = false
                self.tfPalet.textField.isEnabled = false
                self.tfRedCase.textField.isEnabled = false
                self.tfGreenCase.textField.isEnabled = false
                self.tf22BlackFoodCase.textField.isEnabled = false
                self.tfBigBlackCase.textField.isEnabled = false
                self.tfPercentFire.textField.isEnabled = false
                self.tfKgPrice.textField.isEnabled = false
                self.tfPaletDari.textField.isEnabled = false
                self.tfRedDari.textField.isEnabled = false
                self.tfGreenDari.textField.isEnabled = false
                self.tf22BlackDari.textField.isEnabled = false
                self.tfBigBlackDari.textField.isEnabled = false

                self.btnSave.isHidden = true

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
private extension BuyingCollectionViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}

// MARK: TextField
private extension BuyingCollectionViewController {

    func listenTextFieldsDidChange() {
        tfKantarFisi.addListenDidChange { [unowned self] text in
            self.viewModel.setKantarFisi(text)
            self.viewModel.updateResults()
        }

        tfPalet.addListenDidChange { [unowned self] text in
            self.viewModel.setPalet(text)
            self.viewModel.updateResults()
        }

        tfRedCase.addListenDidChange { [unowned self] text in
            self.viewModel.setRedCase(text)
            self.viewModel.updateResults()
        }

        tfGreenCase.addListenDidChange { [unowned self] text in
            self.viewModel.setGreenCase(text)
            self.viewModel.updateResults()
        }

        tf22BlackFoodCase.addListenDidChange { [unowned self] text in
            self.viewModel.set22BlackFoodCase(text)
            self.viewModel.updateResults()
        }

        tfBigBlackCase.addListenDidChange { [unowned self] text in
            self.viewModel.setBigBlackCase(text)
            self.viewModel.updateResults()
        }

        tfPercentFire.addListenDidChange { [unowned self] text in
            self.viewModel.setPercentFire(text)
            self.viewModel.updateResults()
        }

        tfKgPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setKgPrice(text)
            self.viewModel.updateResults()
        }

        tfPaletDari.addListenDidChange { [unowned self] text in
            self.viewModel.setPaletDari(text)
            self.viewModel.updateResults()
        }

        tfRedDari.addListenDidChange { [unowned self] text in
            self.viewModel.setRedDari(text)
            self.viewModel.updateResults()
        }

        tfGreenDari.addListenDidChange { [unowned self] text in
            self.viewModel.setGreenDari(text)
            self.viewModel.updateResults()
        }

        tf22BlackDari.addListenDidChange { [unowned self] text in
            self.viewModel.set22BlackDari(text)
            self.viewModel.updateResults()
        }

        tfBigBlackDari.addListenDidChange { [unowned self] text in
            self.viewModel.setBigBlackDari(text)
            self.viewModel.updateResults()
        }
    }
}
