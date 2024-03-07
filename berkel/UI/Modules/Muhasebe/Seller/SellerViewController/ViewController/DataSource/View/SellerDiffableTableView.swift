//
//  SellerDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.11.2023.
//

import UIKit

typealias SellerSnapshot = NSDiffableDataSourceSnapshot<SellerSection, SellerRowModel>

final class SellerDiffableTableView: UITableView {

    private weak var delegateManager: SellerDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var sellerDataSource: SellerDataSource = {
        return SellerDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension SellerDiffableTableView {

    func configureView(delegateManager: SellerDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: SellerSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.sellerDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> SellerSnapshot {
        return self.sellerDataSource.snapshot()
    }
}

// MARK: Init
private extension SellerDiffableTableView {

    func initializeTableView() {
        self.registerCell(SellerTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.sellerDataSource
        self.dataSource = self.sellerDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
