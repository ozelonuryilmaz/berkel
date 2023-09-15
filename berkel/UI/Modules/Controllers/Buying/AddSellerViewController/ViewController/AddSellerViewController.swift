//
//  AddSellerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class AddSellerViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Yeni Satıcı Ekle"
    }

    // MARK: Constants
    @IBOutlet private weak var tfName: PrimaryTextField!
    @IBOutlet private weak var tfTC: PrimaryTextField!
    @IBOutlet private weak var tfPhone: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Inject
    private let viewModel: IAddSellerViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IAddSellerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AddSellerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        
        self.listenNameTextFieldDidChange()
        self.listenTCTextFieldDidChange()
        self.listenPhoneTextFieldDidChange()
        self.listenDescTextFieldDidChange()
        self.observeViewState()
        self.listenErrorState()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveNewSeller()
        }
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

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
private extension AddSellerViewController {

    
}

// MARK: TextField
private extension AddSellerViewController {

    func listenNameTextFieldDidChange() {
        tfName.addListenDidChange { [unowned self] text in
            self.viewModel.setName(text)
        }
    }

    func listenTCTextFieldDidChange() {
        tfTC.addListenDidChange { [unowned self] text in
            self.viewModel.setTC(text)
        }
    }

    func listenPhoneTextFieldDidChange() {
        tfPhone.addListenDidChange { [unowned self] text in
            self.viewModel.setPhone(text)
        }
    }

    func listenDescTextFieldDidChange() {
        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
