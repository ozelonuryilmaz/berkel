//
//  OtherDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import UIKit

typealias OtherSnapshot = NSDiffableDataSourceSnapshot<OtherSection, OtherRowModel>

final class OtherDiffableTableView: UITableView {

    private weak var delegateManager: OtherDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var otherDataSource: OtherDataSource = {
        return OtherDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension OtherDiffableTableView {

    func configureView(delegateManager: OtherDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: OtherSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.otherDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> OtherSnapshot {
        return self.otherDataSource.snapshot()
    }
}

// MARK: Init
private extension OtherDiffableTableView {

    func initializeTableView() {
        self.registerCell(OtherTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.otherDataSource
        self.dataSource = self.otherDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
