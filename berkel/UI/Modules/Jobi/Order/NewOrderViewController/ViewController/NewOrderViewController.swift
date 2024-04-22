//
//  NewOrderViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol NewOrderViewControllerOutputDelegate: AnyObject {
    func newOrderItemData(_ data: OrderModel)
}

final class NewOrderViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Yeni Sipariş"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewOrderViewModel
    private weak var outputDelegate: NewOrderViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var lblOrderName: UILabel!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: INewOrderViewModel,
         outputDelegate: NewOrderViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewOrderViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        
        self.viewModel.initComponents()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveNewOrder()
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

            case .outputDelegate(let newOrderItemData):
                self.outputDelegate?.newOrderItemData(newOrderItemData)

            case .setJBCustomerName(let name):
                self.lblOrderName.text = name
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
            self.viewModel.dismiss(completion: nil)
        }
    }()
}

// MARK: Props
private extension NewOrderViewController {

    func listenTextFieldsDidChange() {

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}

