//
//  AddBuyingItemDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

typealias AddBuyingItemSnapshot = NSDiffableDataSourceSnapshot<AddBuyingItemSection, AddBuyingItemRowModel>

final class AddBuyingItemDiffableTableView: UITableView {

    private weak var delegateManager: AddBuyingItemDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var addBuyingItemDataSource: AddBuyingItemDataSource = {
        return AddBuyingItemDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension AddBuyingItemDiffableTableView {

    func configureView(delegateManager: AddBuyingItemDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: AddBuyingItemSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.addBuyingItemDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> AddBuyingItemSnapshot {
        return self.addBuyingItemDataSource.snapshot()
    }
}

// MARK: Init
private extension AddBuyingItemDiffableTableView {

    func initializeTableView() {
        self.registerCell(AddBuyingItemTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.addBuyingItemDataSource
        self.dataSource = self.addBuyingItemDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
