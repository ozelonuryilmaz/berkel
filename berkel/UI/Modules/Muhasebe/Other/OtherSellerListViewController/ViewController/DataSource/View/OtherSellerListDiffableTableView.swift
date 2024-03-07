//
//  OtherSellerListDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

typealias OtherSellerListSnapshot = NSDiffableDataSourceSnapshot<OtherSellerListSection, OtherSellerListRowModel>

final class OtherSellerListDiffableTableView: UITableView {

    private weak var delegateManager: OtherSellerListDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var otherSellerListDataSource: OtherSellerListDataSource = {
        return OtherSellerListDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension OtherSellerListDiffableTableView {

    func configureView(delegateManager: OtherSellerListDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: OtherSellerListSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.otherSellerListDataSource.applySnapshot(snapshot,
                                                     animated: animated,
                                                     completion: completion)
    }

    func getSnapshot() -> OtherSellerListSnapshot {
        return self.otherSellerListDataSource.snapshot()
    }
}

// MARK: Init
private extension OtherSellerListDiffableTableView {

    func initializeTableView() {
        self.registerCell(OtherSellerListTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.otherSellerListDataSource
        self.dataSource = self.otherSellerListDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
