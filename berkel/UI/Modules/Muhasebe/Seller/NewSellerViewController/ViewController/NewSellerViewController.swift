//
//  NewSellerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit
import Combine

protocol NewSellerViewControllerOutputDelegate: AnyObject {
    func newSellerData(_ data: SellerModel)
}

final class NewSellerViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Yeni Satım Oluştur"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewSellerViewModel
    private var outputDelegate: NewSellerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var lblCustomerName: UILabel!
    @IBOutlet private weak var btnProductList: UIButton!
    @IBOutlet private weak var tfKGPrice: PrimaryTextField!
    @IBOutlet private weak var tfKDV: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewSellerViewModel,
         outputDelegate: NewSellerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewSellerViewController", bundle: nil)
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
        
        btnProductList.onTap { [unowned self] _ in
            self.viewModel.presentProductListViewController()
        }

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveNewSeller()
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
                
            case .setCustomerName(let name):
                self.lblCustomerName.text = name
                
            case .outputDelegate(let sellerModel):
                self.outputDelegate?.newSellerData(sellerModel)
                
            case .setProductName(let name):
                self.btnProductList.setTitle(name, for: .normal)
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
private extension NewSellerViewController {

    func listenTextFieldsDidChange() {
        
        tfKGPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setKGPrice(text)
        }
        
        tfKDV.addListenDidChange { [unowned self] text in
            self.viewModel.setKDV(text)
        }
        
        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
