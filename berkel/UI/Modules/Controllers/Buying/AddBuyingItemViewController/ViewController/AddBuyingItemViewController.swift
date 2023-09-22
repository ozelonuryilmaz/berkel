//
//  AddBuyingItemViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class AddBuyingItemViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Alım Oluştur"
    }

    override var isShowTabbar: Bool {
        return false
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IAddBuyingItemViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: AddBuyingItemDiffableTableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IAddBuyingItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AddBuyingItemViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeViewState()
        self.listenErrorState()

        self.viewModel.getBuyingItems()
    }

    override func setupView() {
        initTableView()
    }

    override func registerEvents() {

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
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(
            viewController: self,
            callbackOverrideAlert: nil,
            callbackAlertButtonAction: { [unowned self] in
                self.viewModel.getBuyingItems()
            }
        )
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addPersonNav) { [unowned self] _ in
            self.viewModel.presentAddSellerViewController()
        }
    }()
}

// MARK: Props
private extension AddBuyingItemViewController {

    func initTableView() {
        self.tableView.configureView(delegateManager: self.viewModel)
    }
}
