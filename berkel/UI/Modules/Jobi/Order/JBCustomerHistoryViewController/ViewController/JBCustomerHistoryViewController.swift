//
//  JBCustomerHistoryViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol JBCustomerHistoryViewControllerOutputDelegate: AnyObject {

}

final class JBCustomerHistoryViewController: BerkelBaseViewController {

    // MARK: Constants
    override var navigationTitle: String? {
        return viewModel.customerName
    }
    
    override var navigationSubTitle: String? {
        return "\(viewModel.season) Sipariş Geçmişi"
    }

    // MARK: Inject
    private let viewModel: IJBCustomerHistoryViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var startDatePicker: UIDatePicker!
    @IBOutlet private weak var endDatePicker: UIDatePicker!
    @IBOutlet private weak var btnConfirm: UIButton!

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: IJBCustomerHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "JBCustomerHistoryViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
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
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.selfDismiss()
        }
    }()
}

// MARK: Props
private extension JBCustomerHistoryViewController {
    
}
