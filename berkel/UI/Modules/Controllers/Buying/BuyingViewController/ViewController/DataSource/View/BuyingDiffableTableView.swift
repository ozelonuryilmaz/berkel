//
//  BuyingDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 29.09.2023.
//

import UIKit

typealias BuyingSnapshot = NSDiffableDataSourceSnapshot<BuyingSection, BuyingRowModel>

final class BuyingDiffableTableView: UITableView {

    private weak var delegateManager: BuyingDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var buyingDataSource: BuyingDataSource = {
        return BuyingDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension BuyingDiffableTableView {

    func configureView(delegateManager: BuyingDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: BuyingSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.buyingDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> BuyingSnapshot {
        return self.buyingDataSource.snapshot()
    }
}

// MARK: Init
private extension BuyingDiffableTableView {

    func initializeTableView() {
        self.registerCell(BuyingTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.buyingDataSource
        self.dataSource = self.buyingDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
