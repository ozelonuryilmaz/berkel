//
//  StockDetailInfoDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//

import UIKit

typealias StockDetailInfoSnapshot = NSDiffableDataSourceSnapshot<StockDetailInfoSection, StockDetailInfoRowModel>

final class StockDetailInfoDiffableTableView: UITableView {

    private weak var delegateManager: StockDetailInfoDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var stockDetailInfoDataSource: StockDetailInfoDataSource = {
        return StockDetailInfoDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension StockDetailInfoDiffableTableView {

    func configureView(delegateManager: StockDetailInfoDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: StockDetailInfoSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.stockDetailInfoDataSource.applySnapshot(snapshot,
                                                     animated: animated,
                                                     completion: completion)
    }

    func getSnapshot() -> StockDetailInfoSnapshot {
        return self.stockDetailInfoDataSource.snapshot()
    }
}

// MARK: Init
private extension StockDetailInfoDiffableTableView {

    func initializeTableView() {
        self.registerCell(StockDetailInfoTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 72, right: 0)
        self.delegate = self.stockDetailInfoDataSource
        self.dataSource = self.stockDetailInfoDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
