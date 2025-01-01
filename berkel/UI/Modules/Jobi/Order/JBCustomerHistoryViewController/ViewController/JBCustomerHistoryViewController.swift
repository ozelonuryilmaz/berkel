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
    @IBOutlet private weak var tableView: UITableView!

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
        self.initTableView()
        self.viewModel.getDatas()
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

            case .reloadData:
                self.tableView.reloadData()
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
    
    func initTableView() {
        tableView.registerHeaderFooterView(StockHeaderCell.self)
        tableView.registerCell(StockItemCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}


// MARK: UITableViewDelegate & UITableViewDataSource
extension JBCustomerHistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInRow(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(StockItemCell.self, indexPath: indexPath)
        cell.configureCell(with: viewModel.getItemCellUIModel(indexPath: indexPath),
                           isArrowIconHidden: true)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.generateReusableHeaderFooterView(StockHeaderCell.self)
        sectionView.configureCell(with: self.viewModel.getSectionUIModel(section: section),
                                  isDateHidden: true)
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsHeaderCell.defaultHeight + 32 // 32 for date
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}

