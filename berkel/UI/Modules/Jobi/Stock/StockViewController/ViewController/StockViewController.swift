//
//  StockViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit
import Combine

final class StockViewController: JobiBaseViewController {
    
    override var navigationTitle: String? {
        return "Stok"
    }
    
    override var navigationSubTitle: String? {
        return self.viewModel.season
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IStockViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IStockViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "StockViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeReactiveDatas()
    }

    override func registerEvents() {

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

            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.viewModel.pushMyStockListViewController()
        }
    }()
}

// MARK: Props
private extension StockViewController {

}
