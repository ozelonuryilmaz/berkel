//
//  OrderDetailCollectionDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import UIKit

typealias OrderDetailCollectionSnapshot = NSDiffableDataSourceSnapshot<OrderDetailCollectionSection, OrderDetailCollectionRowModel>

final class OrderDetailCollectionDiffableTableView: UITableView {

    private weak var delegateManager: OrderDetailCollectionDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var orderDetailCollectionDataSource: OrderDetailCollectionDataSource = {
        return OrderDetailCollectionDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension OrderDetailCollectionDiffableTableView {

    func configureView(delegateManager: OrderDetailCollectionDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: OrderDetailCollectionSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.orderDetailCollectionDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> OrderDetailCollectionSnapshot {
        return self.orderDetailCollectionDataSource.snapshot()
    }
}

// MARK: Init
private extension OrderDetailCollectionDiffableTableView {

    func initializeTableView() {
        self.registerCell(OrderDetailCollectionTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        self.delegate = self.orderDetailCollectionDataSource
        self.dataSource = self.orderDetailCollectionDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
