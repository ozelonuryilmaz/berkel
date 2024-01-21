//
//  NewOtherItemViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit
import Combine

protocol NewOtherItemViewControllerOutputDelegate: AnyObject {
    func newOtherItemData(_ data: OtherModel)
}

final class NewOtherItemViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Yeni Diğer Alım Oluştur"
    }

    // MARK: Inject
    private let viewModel: INewOtherItemViewModel
    private var outputDelegate: NewOtherItemViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var lblOtherSellerName: UILabel!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Initializer
    init(viewModel: INewOtherItemViewModel,
         outputDelegate: NewOtherItemViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewOtherItemViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()

        self.viewModel.initComponents()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveNewOther()
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

            case .outputDelegate(let newOtherItemData):
                self.outputDelegate?.newOtherItemData(newOtherItemData)

            case .setOtherSellerName(let name, let categoryName):
                self.lblOtherSellerName.text = "\(name) (\(categoryName))"
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
private extension NewOtherItemViewController {

    func listenTextFieldsDidChange() {

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
