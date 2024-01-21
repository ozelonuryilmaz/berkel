//
//  CustomerListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit
import Combine

final class CustomerListViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Müşteri Listesi"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ICustomerListViewModel
    private weak var outputDelegate: NewSellerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: CustomerListDiffableTableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ICustomerListViewModel,
         outputDelegate: NewSellerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "CustomerListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeReactiveDatas()

        self.viewModel.getCustomerList()
    }

    override func setupView() {
        initTableView()
    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            case .buildSnapshot(let snapshot):
                self.tableView.applySnapshot(snapshot)

            case .updateSnapshot(let data):
                let snapsoht = self.viewModel.updateSnapshot(currentSnapshot: self.tableView.getSnapshot(),
                                                             newDatas: data)
                self.tableView.applySnapshot(snapsoht)

            case .outputDelegate(let sellerModel):
                self.outputDelegate?.newSellerData(sellerModel)

            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(
            viewController: self,
            callbackOverrideAlert: nil,
            callbackAlertButtonAction: { [unowned self] in
                self.viewModel.getCustomerList()
            }
        )
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addPersonNav) { [unowned self] _ in
            self.viewModel.presentNewCustomerViewController(passData: NewCustomerPassData(customerInformation: nil))
        }
    }()
}

// MARK: Props
private extension CustomerListViewController {

    func initTableView() {
        self.tableView.configureView(delegateManager: self.viewModel)
    }
}
