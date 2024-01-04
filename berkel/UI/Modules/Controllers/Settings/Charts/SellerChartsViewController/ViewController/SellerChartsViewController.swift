//
//  SellerChartsViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.12.2023.
//

import UIKit
import Combine

final class SellerChartsViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Satış Çizelgesi"
    }

    override var navigationSubTitle: String? {
        return self.viewModel.season
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ISellerChartsViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblOldDoubt: UILabel!
    @IBOutlet private weak var lblNowDoubt: UILabel!
    @IBOutlet private weak var tableViewSellerDetail: SellerDetailCollectionDiffableTableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ISellerChartsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SellerChartsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        self.viewModel.getList()
    }

    override func setupView() {
        initTableViewSellerDetail()
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
                self.tableViewSellerDetail.applySnapshot(snapshot)
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
private extension SellerChartsViewController {

    func initTableViewSellerDetail() {
        self.tableViewSellerDetail.configureView(delegateManager: self.viewModel)
    }
}
