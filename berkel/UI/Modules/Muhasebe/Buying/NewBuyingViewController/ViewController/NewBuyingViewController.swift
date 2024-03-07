//
//  NewBuyingViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//

import UIKit

final class NewBuyingViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Yeni Alım Oluştur"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewBuyingViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblSellerName: UILabel!
    @IBOutlet private weak var lblSellerTCKN: UILabel!
    @IBOutlet private weak var btnProductList: UIButton!
    @IBOutlet private weak var tfPrice: PrimaryTextField!
    @IBOutlet private weak var tfPayment: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewBuyingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "NewBuyingViewController", bundle: nil)
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
            self.viewModel.saveNewBuying()
        }
    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()

        listenPriceTextFieldDidChange()
        listenPaymentTextFieldDidChange()
        listenDescTextFieldDidChange()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            case .setSellerName(let name):
                self.lblSellerName.text = name
            case .setSellerTCKN(let tckn):
                self.lblSellerTCKN.text = tckn
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
            self.viewModel.dismiss()
        }
    }()
}

// MARK: Props
private extension NewBuyingViewController {

}

// MARK: TextField
private extension NewBuyingViewController {

    func listenPriceTextFieldDidChange() {
        tfPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setPrice(text)
        }
    }

    func listenPaymentTextFieldDidChange() {
        tfPayment.addListenDidChange { [unowned self] text in
            self.viewModel.setPayment(text)
        }
    }

    func listenDescTextFieldDidChange() {
        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
