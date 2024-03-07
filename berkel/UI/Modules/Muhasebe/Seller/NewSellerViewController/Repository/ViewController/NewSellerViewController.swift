//
//  NewSellerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit
import Combine

final class NewSellerViewController: MainBaseViewController / BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewSellerViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewSellerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "NewSellerViewController", bundle: nil)
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
private extension NewSellerViewController {

}
