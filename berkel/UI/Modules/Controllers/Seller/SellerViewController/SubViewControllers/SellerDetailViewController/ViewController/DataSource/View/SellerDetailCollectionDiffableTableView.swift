//
//  SellerDetailCollectionDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import UIKit

typealias SellerDetailCollectionSnapshot = NSDiffableDataSourceSnapshot<SellerDetailCollectionSection, SellerDetailCollectionRowModel>

final class SellerDetailCollectionDiffableTableView: UITableView {

    private weak var delegateManager: SellerDetailCollectionDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var sellerDetailCollectionDataSource: SellerDetailCollectionDataSource = {
        return SellerDetailCollectionDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension SellerDetailCollectionDiffableTableView {

    func configureView(delegateManager: SellerDetailCollectionDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: SellerDetailCollectionSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.sellerDetailCollectionDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> SellerDetailCollectionSnapshot {
        return self.sellerDetailCollectionDataSource.snapshot()
    }
}

// MARK: Init
private extension SellerDetailCollectionDiffableTableView {

    func initializeTableView() {
        self.registerCell(SellerDetailCollectionTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.delegate = self.sellerDetailCollectionDataSource
        self.dataSource = self.sellerDetailCollectionDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
