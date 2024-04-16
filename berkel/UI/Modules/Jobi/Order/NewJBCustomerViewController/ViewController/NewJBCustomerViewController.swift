//
//  NewJBCustomerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol NewJBCustomerViewControllerOutputDelegate: AnyObject {

    func newJBCustomerData(_ data: JBCustomerModel)
}

final class NewJBCustomerViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewJBCustomerViewModel
    private weak var outputDelegate: NewJBCustomerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tfName: PrimaryTextField!
    @IBOutlet private weak var tfPhone: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewJBCustomerViewModel,
         outputDelegate: NewJBCustomerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewJBCustomerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
        self.viewModel.initData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.viewWillAppear()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveNewCustomer()
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

            case .showSavedCustomer(let data):
                self.outputDelegate?.newJBCustomerData(data)

            case .initData(let name, let phoneNumber, let desc):
                self.tfName.placeholder = name
                self.tfPhone.text = phoneNumber
                self.tfDesc.text = desc

            case .disableNameTextField:
                self.tfName.textField.disable()

            case .updateNavigationTitle(let title):
                self.navigationItem.title = title
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
private extension NewJBCustomerViewController {

}

// MARK: TextField
private extension NewJBCustomerViewController {

    func listenTextFieldsDidChange() {
        tfName.addListenDidChange { [unowned self] text in
            self.viewModel.setName(text)
        }

        tfPhone.addListenDidChange { [unowned self] text in
            self.viewModel.setPhone(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
