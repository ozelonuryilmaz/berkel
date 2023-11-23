//
//  NewCustomerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit
import Combine

protocol NewCustomerViewControllerOutputDelegate: AnyObject {
    func newCustomerData(_ data: CustomerModel)
}

final class NewCustomerViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Yeni Müşteri Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewCustomerViewModel
    private weak var outputDelegate: NewCustomerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tfName: PrimaryTextField!
    @IBOutlet private weak var tfPhone: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewCustomerViewModel,
         outputDelegate: NewCustomerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewCustomerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
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
                self.outputDelegate?.newCustomerData(data)
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
private extension NewCustomerViewController {

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
