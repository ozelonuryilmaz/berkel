//
//  ArchiveDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit
import Combine

final class ArchiveDetailViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IArchiveDetailViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IArchiveDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ArchiveDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()

        self.viewModel.initComponents()
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

            case .setNavigationTitle(let title, let subtitle):
                self.navigationItem.setCustomTitle(title, subtitle: subtitle)

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
private extension ArchiveDetailViewController {

}
