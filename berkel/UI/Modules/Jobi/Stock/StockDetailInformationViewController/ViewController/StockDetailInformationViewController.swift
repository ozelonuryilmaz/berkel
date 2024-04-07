//
//  StockDetailInformationViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit
import Combine

final class StockDetailInformationViewController: JobiBaseViewController {

    override var navigationTitle: String? {
        return self.viewModel.navigationTitle
    }

    override var navigationSubTitle: String? {
        return self.viewModel.navigationSubTitle
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IStockDetailInformationViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: StockDetailInfoDiffableTableView!
    @IBOutlet private weak var btnAddStock: UIButton!
    @IBOutlet private weak var btnRemoveStock: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IStockDetailInformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "StockDetailInformationViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()

        self.viewModel.getStockList()
    }

    override func setupView() {
        initTableView()
    }

    override func registerEvents() {

        btnAddStock.onTap { [unowned self] _ in
            self.viewModel.presentUpdateStockViewController(type: .add)
        }

        btnRemoveStock.onTap { [unowned self] _ in
            self.viewModel.presentUpdateStockViewController(type: .remove)
        }
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
private extension StockDetailInformationViewController {

    func initTableView() {
        self.tableView.configureView(delegateManager: self.viewModel)
    }
}
