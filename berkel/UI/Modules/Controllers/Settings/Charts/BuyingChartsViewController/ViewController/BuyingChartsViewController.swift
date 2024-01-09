//
//  BuyingChartsViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.01.2024.
//

import UIKit
import Combine

final class BuyingChartsViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Alış Çizelgesi"
    }

    override var navigationSubTitle: String? {
        return self.viewModel.season
    }

    // MARK: Inject
    private let viewModel: IBuyingChartsViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblOldDoubt: UILabel!
    @IBOutlet private weak var lblNowDoubt: UILabel!
    @IBOutlet private weak var tableViewBuyingDetail: BuyingCollectionDiffableTableView!

    // MARK: Initializer
    init(viewModel: IBuyingChartsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingChartsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        self.viewModel.getList()
    }

    override func setupView() {
        initTableViewBuyingDetail()
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
            case .oldDoubt(let text):
                self.lblOldDoubt.text = text
            case .nowDoubt(let text):
                self.lblNowDoubt.text = text

            case .buildCollectionSnapshot(let snapshot):
                self.tableViewBuyingDetail.applySnapshot(snapshot)
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
private extension BuyingChartsViewController {

    func initTableViewBuyingDetail() {
        self.tableViewBuyingDetail.configureView(delegateManager: self.viewModel)
    }
}
