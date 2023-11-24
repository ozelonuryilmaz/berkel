//
//  SellerDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit
import Combine

protocol SellerDetailViewControllerOutputDelegate: AnyObject {

    func closeButtonTapped(sellerId: String, isActive: Bool)
}

final class SellerDetailViewController: MainBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ISellerDetailViewModel
    private weak var outputDelegate: SellerDetailViewControllerOutputDelegate? = nil

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ISellerDetailViewModel,
         outputDelegate: SellerDetailViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "SellerDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
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
}

// MARK: Props
private extension SellerDetailViewController {

}
