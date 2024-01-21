//
//  NewOtherSellerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit
import Combine

protocol NewOtherSellerViewControllerOutputDelegate: AnyObject {
    func otherSellerData(_ data: OtherSellerModel)
}

final class NewOtherSellerViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewOtherSellerViewModel
    private var outputDelegate: NewOtherSellerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tfName: PrimaryTextField!
    @IBOutlet private weak var tfPhone: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!
    @IBOutlet private weak var btnCategory: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewOtherSellerViewModel,
         outputDelegate: NewOtherSellerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewOtherSellerViewController", bundle: nil)
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
            self.viewModel.saveNewOtherSeller()
        }

        btnCategory.onTap { [unowned self] _ in
            self.viewModel.presentOtherSellerCategoryListViewController()
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

            case .showSavedOtherSeller(let data):
                self.outputDelegate?.otherSellerData(data)

            case .initData(let categoryName, let name, let phoneNumber, let desc):
                self.btnCategory.setTitle(categoryName, for: .normal)
                self.tfName.placeholder = name
                self.tfPhone.text = phoneNumber
                self.tfDesc.text = desc

            case .disableNameTextField:
                self.tfName.textField.disable()

            case .updateNavigationTitle(let title):
                self.navigationItem.title = title

            case .setCategoryName(let name):
                self.btnCategory.setTitle(name, for: .normal)
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
private extension NewOtherSellerViewController {

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
