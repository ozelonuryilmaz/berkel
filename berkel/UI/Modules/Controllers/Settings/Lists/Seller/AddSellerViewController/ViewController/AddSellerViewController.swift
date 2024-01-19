//
//  AddSellerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//

import UIKit

protocol AddSellerViewControllerOutputDelegate: AnyObject {
    func newAddSellerData(_ data: AddSellerModel)
}

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
    private weak var outputDelegate: AddSellerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IAddSellerViewModel,
         outputDelegate: AddSellerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
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

        self.viewModel.initData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.viewWillAppear()
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

            case .showSavedSeller(let data):
                self.outputDelegate?.newAddSellerData(data)

            case .initData(let name, let tc, let phoneNumber, let desc):
                self.tfName.placeholder = name
                self.tfTC.text = tc
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
