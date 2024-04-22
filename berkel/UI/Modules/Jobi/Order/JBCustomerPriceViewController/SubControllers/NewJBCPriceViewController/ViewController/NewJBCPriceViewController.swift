//
//  NewJBCPriceViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol NewJBCPriceViewControllerOutputDelegate: AnyObject {

    func newJBCPriceData(_ data: JBCPriceModel)
}

final class NewJBCPriceViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Fiyat Ekle"
    }
    
    override var navigationSubTitle: String? {
        return viewModel.navTitle
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewJBCPriceViewModel
    private weak var outputDelegate: NewJBCPriceViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var tfCount: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: INewJBCPriceViewModel,
         outputDelegate: NewJBCPriceViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewJBCPriceViewController", bundle: nil)
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
    }

    override func registerEvents() {
        btnSave.onTap { [unowned self] _ in
            self.viewModel.savePrice()
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

            case .showSystemAlert(let title, let message):
                self.showSystemAlert(title: title, message: message)
                
            case .showSavedJBCPriceData(let data):
                self.outputDelegate?.newJBCPriceData(data)
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
private extension NewJBCPriceViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}

// MARK: TextField
private extension NewJBCPriceViewController {

    func listenTextFieldsDidChange() {
        tfCount.addListenDidChange { [unowned self] text in
            self.viewModel.setCount(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
