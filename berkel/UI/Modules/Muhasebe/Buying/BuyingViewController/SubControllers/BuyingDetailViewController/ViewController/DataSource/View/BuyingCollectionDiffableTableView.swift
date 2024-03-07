//
//  BuyingCollectionDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

typealias BuyingCollectionSnapshot = NSDiffableDataSourceSnapshot<BuyingCollectionSection, BuyingCollectionRowModel>

final class BuyingCollectionDiffableTableView: UITableView {

    private weak var delegateManager: BuyingCollectionDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var buyingCollectionDataSource: BuyingCollectionDataSource = {
        return BuyingCollectionDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension BuyingCollectionDiffableTableView {

    func configureView(delegateManager: BuyingCollectionDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: BuyingCollectionSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.buyingCollectionDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> BuyingCollectionSnapshot {
        return self.buyingCollectionDataSource.snapshot()
    }
}

// MARK: Init
private extension BuyingCollectionDiffableTableView {

    func initializeTableView() {
        self.registerCell(BuyingCollectionTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.delegate = self.buyingCollectionDataSource
        self.dataSource = self.buyingCollectionDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
