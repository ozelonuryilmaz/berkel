//
//  OtherSellerChartsViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import UIKit
import Combine

final class OtherSellerChartsViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Hizmet Çizelgesi"
    }

    override var navigationSubTitle: String? {
        return self.viewModel.season
    }

    // MARK: Inject
    private let viewModel: IOtherSellerChartsViewModel
    @IBOutlet private weak var lblOldDoubt: UILabel!
    @IBOutlet private weak var lblNowDoubt: UILabel!
    @IBOutlet private weak var tableViewOtherDetail: OtherDetailCollectionDiffableTableView!
    
    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IOtherSellerChartsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "OtherSellerChartsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        self.viewModel.getList()
    }

    override func setupView() {
        initTableViewOtherDetail()
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
                self.tableViewOtherDetail.applySnapshot(snapshot)
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }
}

// MARK: Props
private extension OtherSellerChartsViewController {

    func initTableViewOtherDetail() {
        self.tableViewOtherDetail.configureView(delegateManager: self.viewModel)
    }
}
