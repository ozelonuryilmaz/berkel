//
//  CavusListDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import UIKit

typealias CavusListSnapshot = NSDiffableDataSourceSnapshot<CavusListSection, CavusListRowModel>

final class CavusListDiffableTableView: UITableView {

    private weak var delegateManager: CavusListDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var cavusListDataSource: CavusListDataSource = {
        return CavusListDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension CavusListDiffableTableView {

    func configureView(delegateManager: CavusListDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: CavusListSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.cavusListDataSource.applySnapshot(snapshot,
                                               animated: animated,
                                               completion: completion)
    }

    func getSnapshot() -> CavusListSnapshot {
        return self.cavusListDataSource.snapshot()
    }
}

// MARK: Init
private extension CavusListDiffableTableView {

    func initializeTableView() {
        self.registerCell(CavusListTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.cavusListDataSource
        self.dataSource = self.cavusListDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
