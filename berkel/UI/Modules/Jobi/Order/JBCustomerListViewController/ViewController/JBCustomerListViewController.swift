//
//  JBCustomerListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol JBCustomerListViewControllerOutputDelegate: AnyObject {

}

final class JBCustomerListViewController: JobiBaseViewController {
    
    override var navigationTitle: String? {
        return "Müşteri Listesi"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IJBCustomerListViewModel
    private weak var outputDelegate: JBCustomerListViewControllerOutputDelegate? = nil

    // MARK: IBOutlets

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: IJBCustomerListViewModel,
         outputDelegate: JBCustomerListViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "JBCustomerListViewController", bundle: nil)
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
            case .playNativeLoading(let isProgress):
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
            self.viewModel.presentNewJBCustomerViewController()
        }
    }()
}

// MARK: Props
private extension JBCustomerListViewController {
    
}
