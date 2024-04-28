//
//  OrderDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.04.2024.
//

import UIKit

typealias OrderSnapshot = NSDiffableDataSourceSnapshot<OrderSection, OrderRowModel>

final class OrderDiffableTableView: UITableView {

    private weak var delegateManager: OrderDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var orderDataSource: OrderDataSource = {
        return OrderDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension OrderDiffableTableView {

    func configureView(delegateManager: OrderDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: OrderSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.orderDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> OrderSnapshot {
        return self.orderDataSource.snapshot()
    }
}

// MARK: Init
private extension OrderDiffableTableView {

    func initializeTableView() {
        self.registerCell(OrderTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.orderDataSource
        self.dataSource = self.orderDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
