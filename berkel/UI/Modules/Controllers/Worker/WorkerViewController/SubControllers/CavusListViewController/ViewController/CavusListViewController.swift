//
//  CavusListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit
import Combine

final class CavusListViewController: MainBaseViewController {
    
    override var navigationTitle: String? {
        return "Çavuş Listesi"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ICavusListViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ICavusListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CavusListViewController", bundle: nil)
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
        return UIBarButtonItem(image: .addPersonNav) { [unowned self] _ in
            self.viewModel.presentNewCavusViewController()
        }
    }()
}

// MARK: Props
private extension CavusListViewController {

}
