//
//  WorkerPaymentViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit
import Combine

final class WorkerPaymentViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Ödeme"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IWorkerPaymentViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblCavusName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var tfPayment: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!

    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IWorkerPaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WorkerPaymentViewController", bundle: nil)
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

            case .setCavusName(let name):
                self.lblCavusName.text = name
                
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
private extension WorkerPaymentViewController {
    
    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}

// MARK: TextField
private extension WorkerPaymentViewController {

    func listenTextFieldsDidChange() {
        tfPayment.addListenDidChange { [unowned self] text in
            self.viewModel.setPayment(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
