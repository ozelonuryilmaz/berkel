//
//  WorkerCollectionViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit
import Combine

final class WorkerCollectionViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "İşçi Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IWorkerCollectionViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblCavusName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var lblTotalPrice: UILabel!

    @IBOutlet private weak var btnSave: UIButton!

    @IBOutlet private weak var tfGardenOwner: PrimaryTextField!
    @IBOutlet private weak var tfKesiciCount: PrimaryTextField!
    @IBOutlet private weak var tfAyakciCount: PrimaryTextField!

    @IBOutlet private weak var tfCavusPrice: PrimaryTextField!
    @IBOutlet private weak var tfKesiciPrice: PrimaryTextField!
    @IBOutlet private weak var tfAyakciPrice: PrimaryTextField!
    @IBOutlet private weak var tfServicePrice: PrimaryTextField!
    @IBOutlet private weak var tfOtherPrice: PrimaryTextField!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IWorkerCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WorkerCollectionViewController", bundle: nil)
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

            case .setCavusName(let name):
                self.lblCavusName.text = "\(name)"

            case .setTotalPrice(let price):
                self.lblTotalPrice.text = price + " TL"

            case .initData(let data):
                self.tfGardenOwner.textField.placeholder = data.gardenOwner
                self.tfCavusPrice.textField.placeholder = data.cavusPrice.decimalString() + " TL"
                self.tfKesiciPrice.textField.placeholder = data.kesiciPrice.decimalString() + " TL"
                self.tfAyakciPrice.textField.placeholder = data.ayakciPrice.decimalString() + " TL"
                self.tfServicePrice.textField.placeholder = data.servisPrice.decimalString() + " TL"
                
            case .initCounts(let kesici, let ayakci, let other):
                self.tfKesiciCount.textField.text = kesici.decimalString()
                self.tfAyakciCount.textField.text = ayakci.decimalString()
                self.tfOtherPrice.textField.text = other.decimalString() + " TL"
                
            case .viewedData(let isVisible):
                self.btnSave.isHidden = !isVisible
                self.datePicker.isEnabled = isVisible
                self.tfKesiciCount.textField.isEnabled = isVisible
                self.tfAyakciCount.textField.isEnabled = isVisible
                self.tfGardenOwner.textField.isEnabled = isVisible
                self.tfCavusPrice.textField.isEnabled = isVisible
                self.tfKesiciPrice.textField.isEnabled = isVisible
                self.tfAyakciPrice.textField.isEnabled = isVisible
                self.tfServicePrice.textField.isEnabled = isVisible
                
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
private extension WorkerCollectionViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}

// MARK: TextField
private extension WorkerCollectionViewController {

    func listenTextFieldsDidChange() {
        tfGardenOwner.addListenDidChange { [unowned self] text in
            self.viewModel.setGardenOwner(text)
        }

        tfKesiciCount.addListenDidChange { [unowned self] text in
            self.viewModel.setKesiciCount(text)
            self.viewModel.updateResults()
        }

        tfAyakciCount.addListenDidChange { [unowned self] text in
            self.viewModel.setAyakciCount(text)
            self.viewModel.updateResults()
        }

        tfCavusPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setCavusPrice(text)
            self.viewModel.updateResults()
        }

        tfKesiciPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setKesiciPrice(text)
            self.viewModel.updateResults()
        }

        tfAyakciPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setAyakciPrice(text)
            self.viewModel.updateResults()
        }

        tfServicePrice.addListenDidChange { [unowned self] text in
            self.viewModel.setServicePrice(text)
            self.viewModel.updateResults()
        }

        tfOtherPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setOtherPrice(text)
            self.viewModel.updateResults()
        }
    }
}
