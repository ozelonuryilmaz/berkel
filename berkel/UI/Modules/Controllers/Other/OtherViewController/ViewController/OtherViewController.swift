//
//  OtherViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit
import Combine

final class OtherViewController: MainBaseViewController {
    
    override var navigationTitle: String? {
        return "Diğer"
    }
    
    override var navigationSubTitle: String? {
        return self.viewModel.season
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IOtherViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IOtherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "OtherViewController", bundle: nil)
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
            self.viewModel.pushOtherItemListViewController()
        }
    }()
}

// MARK: Props
private extension OtherViewController {

}
