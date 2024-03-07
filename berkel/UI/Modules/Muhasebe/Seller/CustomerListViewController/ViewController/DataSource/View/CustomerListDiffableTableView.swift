//
//  CustomerListDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit

typealias CustomerListSnapshot = NSDiffableDataSourceSnapshot<CustomerListSection, CustomerListRowModel>

final class CustomerListDiffableTableView: UITableView {

    private weak var delegateManager: CustomerListDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var customerListDataSource: CustomerListDataSource = {
        return CustomerListDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension CustomerListDiffableTableView {

    func configureView(delegateManager: CustomerListDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: CustomerListSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.customerListDataSource.applySnapshot(snapshot,
                                               animated: animated,
                                               completion: completion)
    }

    func getSnapshot() -> CustomerListSnapshot {
        return self.customerListDataSource.snapshot()
    }
}

// MARK: Init
private extension CustomerListDiffableTableView {

    func initializeTableView() {
        self.registerCell(CustomerListTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.customerListDataSource
        self.dataSource = self.customerListDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
