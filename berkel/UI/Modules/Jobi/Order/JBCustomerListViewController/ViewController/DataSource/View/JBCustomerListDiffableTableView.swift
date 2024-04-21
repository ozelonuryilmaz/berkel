//
//  JBCustomerListDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import UIKit

typealias JBCustomerListSnapshot = NSDiffableDataSourceSnapshot<JBCustomerListSection, JBCustomerListRowModel>

final class JBCustomerListDiffableTableView: UITableView {

    private weak var delegateManager: JBCustomerListDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var customerListDataSource: JBCustomerListDataSource = {
        return JBCustomerListDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension JBCustomerListDiffableTableView {

    func configureView(delegateManager: JBCustomerListDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: JBCustomerListSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.customerListDataSource.applySnapshot(snapshot,
                                               animated: animated,
                                               completion: completion)
    }

    func getSnapshot() -> JBCustomerListSnapshot {
        return self.customerListDataSource.snapshot()
    }
}

// MARK: Init
private extension JBCustomerListDiffableTableView {

    func initializeTableView() {
        self.registerCell(JBCustomerListTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.customerListDataSource
        self.dataSource = self.customerListDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
