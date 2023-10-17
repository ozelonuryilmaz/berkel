//
//  BuyingDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit
import Combine

final class BuyingDetailViewController: MainBaseViewController {

    override var isShowTabbar: Bool {
        return false
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IBuyingDetailViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblOldDoubt: UILabel!
    @IBOutlet private weak var lblNowDoubt: UILabel!
    @IBOutlet private weak var segmentedController: UISegmentedControl!
    @IBOutlet private weak var tableViewCollection: BuyingCollectionDiffableTableView!
    @IBOutlet private weak var tableViewPayment: UITableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IBuyingDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        self.viewModel.initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewStateSetNavigationTitle()
    }

    override func setupView() {
        initTableViewCollection()
    }

    override func registerEvents() {
        segmentedController.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.tableViewCollection.isHidden = sender.selectedSegmentIndex == 1
        self.tableViewPayment.isHidden = sender.selectedSegmentIndex == 0
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

            case .setNavigationTitle(let title, let subTitle):
                self.navigationItem.setCustomTitle(title, subtitle: subTitle)

            case .oldDoubt(let text):
                self.lblOldDoubt.text = text
            case .nowDoubt(let text):
                self.lblNowDoubt.text = text

            case .buildCollectionSnapshot(let snapshot):
                self.tableViewCollection.applySnapshot(snapshot)

            case .updateCollectionSnapshot(let data):
                let snapsoht = self.viewModel.updateCollectionSnapshot(currentSnapshot: self.tableViewCollection.getSnapshot(),
                                                                       newDatas: data)
                self.tableViewCollection.applySnapshot(snapsoht)

            }
        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)

        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
}

// MARK: Props
private extension BuyingDetailViewController {

}

// MARK: Props
private extension BuyingDetailViewController {

    func initTableViewCollection() {
        self.tableViewCollection.configureView(delegateManager: self.viewModel)
    }
}
