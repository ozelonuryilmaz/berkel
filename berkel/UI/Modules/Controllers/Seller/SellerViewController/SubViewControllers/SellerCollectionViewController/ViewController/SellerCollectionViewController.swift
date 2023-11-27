//
//  SellerCollectionViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit
import Combine

final class SellerCollectionViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Ürün Ekle"
    }

    // MARK: Constants
    @IBOutlet private weak var lblCustomerName: UILabel!
    @IBOutlet private weak var lblProductName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var lblTotalKG: UILabel!
    @IBOutlet private weak var lblTotalPrice: UILabel!

    @IBOutlet private weak var btnSave: UIButton!

    @IBOutlet private weak var tfDaraliKG: PrimaryTextField!
    @IBOutlet private weak var tfDara: PrimaryTextField!
    @IBOutlet private weak var tfPrice: PrimaryTextField!
    @IBOutlet private weak var tfKDV: PrimaryTextField!
    @IBOutlet private weak var tfFaturaNo: PrimaryTextField!
    @IBOutlet private weak var tfPalet: PrimaryTextField!
    @IBOutlet private weak var tfKasa: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!

    // MARK: Inject
    private let viewModel: ISellerCollectionViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ISellerCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SellerCollectionViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()

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

            case .setCustomerName(let name):
                self.lblCustomerName.text = name

            case .setProductName(let name):
                self.lblProductName.text = "(\(name))"

            case .setPrice(let price):
                self.tfPrice.textField.text = price

            case .setKDV(let kdv):
                self.tfKDV.textField.text = kdv

            case .setTotalKg(let kg):
                self.lblTotalKG.text = kg + " Kg"

            case .setTotalPrice(let price):
                self.lblTotalPrice.text = price + " TL"

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
private extension SellerCollectionViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}


// MARK: TextField
private extension SellerCollectionViewController {

    func listenTextFieldsDidChange() {
        tfDaraliKG.addListenDidChange { [unowned self] text in
            self.viewModel.setDaraliKG(text)
            self.viewModel.updateResults()
        }

        tfDara.addListenDidChange { [unowned self] text in
            self.viewModel.setDara(text)
            self.viewModel.updateResults()
        }

        tfPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setPrice(text)
            self.viewModel.updateResults()
        }

        tfKDV.addListenDidChange { [unowned self] text in
            self.viewModel.setKDV(text)
            self.viewModel.updateResults()
        }

        tfFaturaNo.addListenDidChange { [unowned self] text in
            self.viewModel.setFaturaNo(text)
        }

        tfPalet.addListenDidChange { [unowned self] text in
            self.viewModel.setPalet(text)
        }

        tfKasa.addListenDidChange { [unowned self] text in
            self.viewModel.setKasa(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
